using Godot;
using System;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.JOIN
{
    public partial class LobbyRealtime
    {
        private static WebSocketPeer _realtimeClient;
        private static bool _isListening = false;
        private static bool _isJoinedChannel = false;
        private static int _refCounter = 1;
        
        public static event Action OnLobbyTableChanged;
        public static event Action<string, float, float, float, float, float, float> OnPlayerTransformReceivedAll; 
        
        // 役職データ配信用イベント (targetPlayerId, role, faction)
        public static event Action<string, int, int> OnRoleAssignedReceived;

        /// <summary>
        /// Supabase Realtime (WebSocket) への接続を開始し、lobbies テーブルを購読します。
        /// </summary>
        public static void StartListeningLobbyChanges()
        {
            if (_isListening) return;

            string wsUrl = $"{SessionManager.SupabaseUrl.Replace("https://", "wss://")}/realtime/v1/websocket?apikey={SessionManager.SupabaseAnonKey}";
           
            _realtimeClient = new WebSocketPeer();
            Error err = _realtimeClient.ConnectToUrl(wsUrl);
           
            if (err != Error.Ok)
            {
                GD.PrintErr("❌ Supabase Realtime へのWebSocket接続初期化に失敗しました。");
                return;
            }

            _isListening = true;
            _isJoinedChannel = false;
            GD.Print("🌐 Supabase Realtime (WebSocket) 接続の待機を開始しました。");

            Task.Run(async () => {
                int timeout = 0;
                while (_realtimeClient != null && _realtimeClient.GetReadyState() == WebSocketPeer.State.Connecting && timeout < 30)
                {
                    await Task.Delay(100);
                    timeout++;
                }

                if (_realtimeClient != null && _realtimeClient.GetReadyState() == WebSocketPeer.State.Open)
                {
                    string currentRef = _refCounter.ToString();
                    _refCounter++;

                    var joinPayload = new
                    {
                        topic = "realtime:public:lobbies",
                        @event = "phx_join",
                        payload = new { 
                            config = new { 
                                postgres_changes = new[] { new { @event = "*", schema = "public", table = "lobbies" } },
                                broadcast = new { ack = false }
                            } 
                        },
                        @ref = currentRef
                    };
                    string joinJson = JsonSerializer.Serialize(joinPayload);
                    _realtimeClient.SendText(joinJson);
                    _isJoinedChannel = true;
                    GD.Print($"📡 Supabaseへ lobbies リアルタイム購読 & Broadcast を有効化しました！ (Ref: {currentRef})");
                }
            });
        }

        /// <summary>
        /// WebSocket接続および Supabase チャンネルの phx_join 完了を確実に非同期待機します。
        /// </summary>
        public static async Task<bool> EnsureConnectedAsync(int timeoutMs = 5000)
        {
            StartListeningLobbyChanges();

            int elapsed = 0;
            while ((!_isJoinedChannel || _realtimeClient == null || _realtimeClient.GetReadyState() != WebSocketPeer.State.Open) && elapsed < timeoutMs)
            {
                await Task.Delay(50);
                elapsed += 50;
            }

            if (_isJoinedChannel && _realtimeClient != null && _realtimeClient.GetReadyState() == WebSocketPeer.State.Open)
            {
                // Supabase側でハンドシェイクが確立するまでの安定猶予時間
                await Task.Delay(250);
                return true;
            }

            return false;
        }

        /// <summary>
        /// 毎フレーム呼び出し、WebSocketパケットの回収と各イベントの発火を行います。
        /// </summary>
        public static void PollRealtimeEvents()
        {
            if (!_isListening || _realtimeClient == null) return;

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

                                // Broadcast パケットの識別処理
                                if (ev == "broadcast")
                                {
                                    JsonElement payload = root.GetProperty("payload");
                                    if (payload.TryGetProperty("type", out JsonElement typeElem))
                                    {
                                        string type = typeElem.GetString();

                                        // 1. 位置・回転データの受信
                                        if (type == "transform_all")
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
                                        // 2. 役職割当データの受信
                                        else if (type == "assign_role")
                                        {
                                            string targetPlayerId = payload.GetProperty("target_player_id").GetString();
                                            int role = payload.GetProperty("role").GetInt32();
                                            int faction = payload.GetProperty("faction").GetInt32();

                                            OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);
                                        }
                                    }
                                    continue;
                                }
                            }
                        }
                    }
                    catch 
                    {
                        // パースエラーは無視します
                    }

                    // データベース変更通知（PostgreSQLのレプリケーション検知）
                    string lowerMessage = message.ToLower();
                    if (lowerMessage.Contains("update") || 
                        lowerMessage.Contains("postgres_changes") || 
                        lowerMessage.Contains("\"event\":\"*\""))
                    {
                        string currentCode = SessionManager.Instance.CurrentRoomCode;

                        if (string.IsNullOrEmpty(currentCode) || lowerMessage.Contains(currentCode.ToLower()))
                        {
                            GD.Print("🔔 参加中ロビーのリアルタイムデータベース更新を検知しました。UIを同期します。");
                            OnLobbyTableChanged?.Invoke();
                        }
                    }
                }
            }
            else if (state == WebSocketPeer.State.Closed)
            {
                _isListening = false;
                _isJoinedChannel = false;
                GD.Print("⚠️ Supabase  WebSocket が切断されました。再接続を実行します...");
                StartListeningLobbyChanges();
            }
        }

        /// <summary>
        /// リアルタイム通信の監視を終了し、WebSocket接続を破棄します。
        /// </summary>
        public static void StopListeningLobbyChanges()
        {
            if (_realtimeClient != null)
            {
                _realtimeClient.Close();
                _realtimeClient = null;
            }
            _isListening = false;
            _isJoinedChannel = false;
            GD.Print("🛑 Supabase Realtime 監視を正常にクローズしました。");
        }


        /// <summary>
        /// 自分の最新のフル3D座標（位置XYZ、回転XYZ）を高速に全員へ送信（Broadcast）します。
        /// </summary>
        public static void LobbySendTransformBroadcastAll(float px, float py, float pz, float rx, float ry, float rz)
        {
            if (_realtimeClient == null || _realtimeClient.GetReadyState() != WebSocketPeer.State.Open) return;

            string senderId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(senderId))
            {
                senderId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }

            var broadcastPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "broadcast",
                payload = new
                {
                    type = "transform_all",
                    player_id = senderId, 
                    px,
                    py,
                    pz,
                    rx,
                    ry,
                    rz
                },
                @ref = (string)null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            _realtimeClient.SendText(json);
        }
    }
}