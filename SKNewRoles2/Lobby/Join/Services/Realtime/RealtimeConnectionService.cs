using Godot;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.JOIN.Services.Realtime
{
    public static class RealtimeConnectionService
    {
        internal static WebSocketPeer RealtimeClient { get; private set; }
        internal static bool IsListening { get; set; } = false;
        internal static bool IsJoinedChannel { get; set; } = false;
        private static int _refCounter = 1;

        /// <summary>
        /// Supabase Realtime (WebSocket) への接続を開始し、ルーム専用チャンネルを購読します。
        /// </summary>
        public static void StartListeningLobbyChanges()
        {
            if (IsListening) return;

            string roomCode = SessionManager.Instance.CurrentRoomCode;
            if (string.IsNullOrEmpty(roomCode))
            {
                GD.PrintErr("部屋コードが空です!");
                return;
            }

            string topicName = $"room:{roomCode}";

            string wsUrl = $"{SessionManager.SupabaseUrl.Replace("https://", "wss://")}/realtime/v1/websocket?apikey={SessionManager.SupabaseAnonKey}";
           
            RealtimeClient = new WebSocketPeer();
            Error err = RealtimeClient.ConnectToUrl(wsUrl);
           
            if (err != Error.Ok)
            {
                GD.PrintErr("❌ Supabase Realtime へのWebSocket接続初期化に失敗しました。");
                return;
            }

            IsListening = true;
            IsJoinedChannel = false;
            GD.Print($"🌐 Supabase Realtime 接続待機中 (Topic: {topicName})...");

            Task.Run(async () => {
                int timeout = 0;
                while (RealtimeClient != null && RealtimeClient.GetReadyState() == WebSocketPeer.State.Connecting && timeout < 30)
                {
                    await Task.Delay(100);
                    timeout++;
                }

                if (RealtimeClient != null && RealtimeClient.GetReadyState() == WebSocketPeer.State.Open)
                {
                    string currentRef = _refCounter.ToString();
                    _refCounter++;

                    var joinPayload = new
                    {
                        topic = topicName,
                        @event = "phx_join",
                        payload = new { 
                            config = new { 
                                broadcast = new { ack = false, self = true }
                            } 
                        },
                        @ref = currentRef
                    };
                    string joinJson = JsonSerializer.Serialize(joinPayload);
                    RealtimeClient.SendText(joinJson);
                    IsJoinedChannel = true;
                    GD.Print($"📡 Supabaseチャンネル [{topicName}] への参加リクエストを送信しました！ (Ref: {currentRef})");
                }
            });
        }

        public static async Task<bool> EnsureConnectedAsync(int timeoutMs = 5000)
        {
            StartListeningLobbyChanges();

            int elapsed = 0;
            while ((!IsJoinedChannel || RealtimeClient == null || RealtimeClient.GetReadyState() != WebSocketPeer.State.Open) && elapsed < timeoutMs)
            {
                await Task.Delay(50);
                elapsed += 50;
            }

            if (IsJoinedChannel && RealtimeClient != null && RealtimeClient.GetReadyState() == WebSocketPeer.State.Open)
            {
                await Task.Delay(250);
                return true;
            }

            return false;
        }

        public static void StopListeningLobbyChanges()
        {
            RealtimeClient?.Close();
            RealtimeClient = null;

            IsListening = false;
            IsJoinedChannel = false;
            GD.Print("🛑 Supabase Realtime 監視を正常にクローズしました。");
        }
    }
}