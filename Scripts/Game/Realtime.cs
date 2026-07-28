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
        public static event Action<string, int, int> OnPlayerHpReceived;

        /// <summary>
        /// チャンネル参加完了までポーリングしながら非同期待機
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

            int timeoutCounter = 0;
            while (timeoutCounter < 100)
            {
                _realtimeClient.Poll();
                var state = _realtimeClient.GetReadyState();

                if (state == WebSocketPeer.State.Open)
                {
                    if (!_isJoinedChannel)
                    {
                        SendJoinChannelRequest();
                    }

                    while (_realtimeClient.GetAvailablePacketCount() > 0)
                    {
                        string message = _realtimeClient.GetPacket().GetStringFromUtf8();
                        ProcessWebSocketMessage(message);
                    }

                    if (_isJoinedChannel)
                    {
                        GD.Print("✅ [Realtime] Realtime チャンネルに正常に参加完了しました。");
                        return true;
                    }
                }
                else if (state == WebSocketPeer.State.Closed)
                {
                    GD.PrintErr("❌ [Realtime] 接続確立前に WebSocket が切断されました。");
                    return false;
                }

                await Task.Delay(100);
                timeoutCounter++;
            }

            GD.PrintErr("⚠️ [Realtime] WebSocket 接続待機がタイムアウト(10秒)しました。");
            return false;
        }

        private static void SendJoinChannelRequest()
        {
            var joinPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "phx_join",
                payload = new { config = new { broadcast = new { self = false } } },
                @ref = _refCounter++.ToString()
            };

            _realtimeClient.SendText(JsonSerializer.Serialize(joinPayload));
            GD.Print("📡 [Realtime] phx_join リクエストを送信しました。");
        }

        public static void PollRealtimeEvents()
        {
            if (_realtimeClient == null) return;

            _realtimeClient.Poll();

            while (_realtimeClient.GetAvailablePacketCount() > 0)
            {
                string message = _realtimeClient.GetPacket().GetStringFromUtf8();
                ProcessWebSocketMessage(message);
            }
        }

        private static void ProcessWebSocketMessage(string rawJson)
        {
            try
            {
                using var doc = JsonDocument.Parse(rawJson);
                var root = doc.RootElement;

                if (root.TryGetProperty("event", out var eventProp))
                {
                    string eventName = eventProp.GetString();

                    if (eventName == "phx_reply")
                    {
                        if (root.TryGetProperty("payload", out var payloadProp) &&
                            payloadProp.TryGetProperty("status", out var statusProp) &&
                            statusProp.GetString() == "ok")
                        {
                            _isJoinedChannel = true;
                        }
                    }
                    else if (eventName == "broadcast")
                    {
                        if (root.TryGetProperty("payload", out var payloadProp))
                        {
                            if (payloadProp.TryGetProperty("type", out var typeProp))
                            {
                                string type = typeProp.GetString();

                                if (type == "transform_all")
                                {
                                    string senderId = payloadProp.GetProperty("player_id").GetString();
                                    float px = payloadProp.GetProperty("px").GetSingle();
                                    float py = payloadProp.GetProperty("py").GetSingle();
                                    float pz = payloadProp.GetProperty("pz").GetSingle();
                                    float rx = payloadProp.GetProperty("rx").GetSingle();
                                    float ry = payloadProp.GetProperty("ry").GetSingle();
                                    float rz = payloadProp.GetProperty("rz").GetSingle();

                                    OnPlayerTransformReceivedAll?.Invoke(senderId, px, py, pz, rx, ry, rz);
                                }
                                else if (type == "assign_role")
                                {
                                    string targetPlayerId = payloadProp.GetProperty("target_player_id").GetString();
                                    int role = payloadProp.GetProperty("role").GetInt32();
                                    int faction = payloadProp.GetProperty("faction").GetInt32();

                                    OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);
                                }
                                else if (type == "player_hp")
                                {
                                    string playerId = payloadProp.GetProperty("player_id").GetString();
                                    int currentHp = payloadProp.GetProperty("current_hp").GetInt32();
                                    int maxHp = payloadProp.GetProperty("max_hp").GetInt32();

                                    OnPlayerHpReceived?.Invoke(playerId, currentHp, maxHp);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] JSON 解析エラー: {ex.Message}");
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

        public static void SendHpBroadcast(string playerId, int currentHp, int maxHp)
        {
            if (_realtimeClient == null || _realtimeClient.GetReadyState() != WebSocketPeer.State.Open || !_isJoinedChannel) return;

            var broadcastPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "broadcast",
                payload = new { type = "player_hp", player_id = playerId, current_hp = currentHp, max_hp = maxHp },
                @ref = (string)null
            };

            _realtimeClient.SendText(JsonSerializer.Serialize(broadcastPayload));
        }
    }
}