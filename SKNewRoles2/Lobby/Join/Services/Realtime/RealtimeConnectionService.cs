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
        /// Supabase Realtime (WebSocket) への接続を開始し、lobbies テーブルを購読します。
        /// </summary>
        public static void StartListeningLobbyChanges()
        {
            if (IsListening) return;

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
            GD.Print("🌐 Supabase Realtime (WebSocket) 接続の待機を開始しました。");

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
                    RealtimeClient.SendText(joinJson);
                    IsJoinedChannel = true;
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
            while ((!IsJoinedChannel || RealtimeClient == null || RealtimeClient.GetReadyState() != WebSocketPeer.State.Open) && elapsed < timeoutMs)
            {
                await Task.Delay(50);
                elapsed += 50;
            }

            if (IsJoinedChannel && RealtimeClient != null && RealtimeClient.GetReadyState() != WebSocketPeer.State.Open)
            {
                // Supabase側でハンドシェイクが確立するまでの安定猶予時間
                await Task.Delay(250);
                return true;
            }

            return false;
        }

        /// <summary>
        /// リアルタイム通信の監視を終了し、WebSocket接続を破棄します。
        /// </summary>
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