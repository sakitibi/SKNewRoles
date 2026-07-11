using Godot;
using System;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game
{
    public partial class Realtime
    {
        private static WebSocketPeer _realtimeClient;
        private static bool _isJoinedChannel = false;
        private static int _refCounter = 1;

        public static event Action<string, float, float, float, float, float, float> OnPlayerTransformReceivedAll;
        public static event Action<string, int, int> OnRoleAssignedReceived;

        /// <summary>
        /// チャンネル参加完了までポーリングしながら非同期待機（メインスレッド安全）
        /// </summary>
        public static async Task<bool> EnsureConnectedAsync()
        {
            if (_realtimeClient != null && 
                _realtimeClient.GetReadyState() == WebSocketPeer.State.Open && 
                _isJoinedChannel)
            {
                return true;
            }

            string wsUrl = $"{SessionManager.SupabaseUrl.Replace("https://", "wss://")}/realtime/v1/websocket?apikey={SessionManager.SupabaseAnonKey}";
            
            _realtimeClient = new WebSocketPeer();
            Error err = _realtimeClient.ConnectToUrl(wsUrl);

            if (err != Error.Ok)
            {
                GD.PrintErr("❌ [Realtime] Supabase Realtime への WebSocket 接続初期化に失敗しました。");
                return false;
            }

            _isJoinedChannel = false;
            GD.Print("🌐 [Realtime] MainGame 用 WebSocket 接続を開始しました。");

            // WebSocket が Open になるまで Poll しながら待機
            int timeout = 0;
            while (_realtimeClient != null && timeout < 50)
            {
                _realtimeClient.Poll();
                var state = _realtimeClient.GetReadyState();

                if (state == WebSocketPeer.State.Open)
                {
                    break;
                }
                if (state == WebSocketPeer.State.Closed)
                {
                    GD.PrintErr("❌ [Realtime] WebSocket 接続が Closed になりました。");
                    return false;
                }

                await Task.Delay(100);
                timeout++;
            }

            if (_realtimeClient == null || _realtimeClient.GetReadyState() != WebSocketPeer.State.Open)
            {
                GD.PrintErr("❌ [Realtime] WebSocket の接続タイムアウト。");
                return false;
            }

            // チャンネル参加リクエスト (phx_join) を送信
            string currentRef = _refCounter++.ToString();
            var joinPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "phx_join",
                payload = new
                {
                    config = new
                    {
                        broadcast = new { ack = false, self = true }
                    }
                },
                @ref = currentRef
            };
            
            string joinJson = JsonSerializer.Serialize(joinPayload);
            _realtimeClient.SendText(joinJson);
            _realtimeClient.Poll();
            GD.Print($"📡 [Realtime] チャンネル接続リクエスト送信完了！ (Ref: {currentRef}) サーバー承認待機中...");

            int joinTimeout = 0;
            while (joinTimeout < 60) // 最大6秒待機
            {
                PollRealtimeEvents(); // 受信パケットを消化して _isJoinedChannel を判定

                if (_isJoinedChannel)
                {
                    GD.Print("✅ [Realtime] チャンネル参加承認 (phx_reply: ok) を確認しました！");
                    return true;
                }

                await Task.Delay(100);
                joinTimeout++;
            }

            GD.PrintErr("❌ [Realtime] チャンネル参加承認がタイムアウトしました。");
            return false;
        }

        public static void StartListening()
        {
            _ = EnsureConnectedAsync();
        }

        public static void PollRealtimeEvents()
        {
            if (_realtimeClient == null) return;

            _realtimeClient.Poll();
            var state = _realtimeClient.GetReadyState();

            if (state == WebSocketPeer.State.Open)
            {
                while (_realtimeClient.GetAvailablePacketCount() > 0)
                {
                    byte[] rawPacket = _realtimeClient.GetPacket();
                    string message = rawPacket.GetStringFromUtf8();
                    if (string.IsNullOrEmpty(message)) continue;

                    try
                    {
                        using (JsonDocument doc = JsonDocument.Parse(message))
                        {
                            JsonElement root = doc.RootElement;

                            if (root.TryGetProperty("event", out JsonElement evElem))
                            {
                                string ev = evElem.GetString();

                                if (ev == "phx_reply")
                                {
                                    if (root.TryGetProperty("payload", out JsonElement payload) &&
                                        payload.TryGetProperty("status", out JsonElement statusElem) &&
                                        statusElem.GetString() == "ok")
                                    {
                                        _isJoinedChannel = true;
                                    }
                                }
                                else if (ev == "broadcast")
                                {
                                    JsonElement payload = root.GetProperty("payload");
                                    if (payload.TryGetProperty("type", out JsonElement typeElem))
                                    {
                                        string type = typeElem.GetString();

                                        if (type == "assign_role")
                                        {
                                            string targetPlayerId = payload.GetProperty("target_player_id").GetString();
                                            int role = payload.GetProperty("role").GetInt32();
                                            int faction = payload.GetProperty("faction").GetInt32();

                                            OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);
                                        }
                                        else if (type == "transform_all")
                                        {
                                            string pId = payload.GetProperty("player_id").GetString();
                                            float px = (float)payload.GetProperty("px").GetDouble();
                                            float py = (float)payload.GetProperty("py").GetDouble();
                                            float pz = (float)payload.GetProperty("pz").GetDouble();
                                            float rx = (float)payload.GetProperty("rx").GetDouble();
                                            float ry = (float)payload.GetProperty("ry").GetDouble();
                                            float rz = (float)payload.GetProperty("rz").GetDouble();

                                            OnPlayerTransformReceivedAll?.Invoke(pId, px, py, pz, rx, ry, rz);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch { }
                }
            }
        }

        public static void SendTransformBroadcastAll(float px, float py, float pz, float rx, float ry, float rz)
        {
            if (_realtimeClient == null || _realtimeClient.GetReadyState() != WebSocketPeer.State.Open || !_isJoinedChannel) return;

            string senderId = SessionManager.Instance.CurrentSession?.User?.Id ?? $"Guest_{SessionManager.Instance.CurrentRoomCode}";

            var broadcastPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "broadcast",
                payload = new { type = "transform_all", player_id = senderId, px, py, pz, rx, ry, rz },
                @ref = (string)null
            };

            _realtimeClient.SendText(JsonSerializer.Serialize(broadcastPayload));
        }

        public static void SendRoleBroadcast(string targetPlayerId, int role, int faction)
        {
            if (_realtimeClient == null || _realtimeClient.GetReadyState() != WebSocketPeer.State.Open || !_isJoinedChannel)
            {
                GD.PrintErr("❌ [Realtime] チャンネル参加が完了していないため SendRoleBroadcast を送信できませんでした。");
                return;
            }

            var broadcastPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "broadcast",
                payload = new { type = "assign_role", target_player_id = targetPlayerId, role, faction },
                @ref = (string)null
            };

            _realtimeClient.SendText(JsonSerializer.Serialize(broadcastPayload));
            GD.Print($"📡 [Realtime] 役職データ送信成功: Target={targetPlayerId}, Role={role}, Faction={faction}");
        }
    }
}