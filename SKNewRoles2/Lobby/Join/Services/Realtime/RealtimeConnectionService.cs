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
        /// Supabase Realtime (WebSocket) への接続を開始し、lobbies チャンネルを購読します。
        /// </summary>
        public static void StartListeningLobbyChanges()
        {
            if (IsListening) return;

            string topicName = "realtime:public:lobbies";

            string wsUrl = $"{SessionManager.SupabaseUrl.Replace("https://", "wss://")}/realtime/v1/websocket?apikey={SessionManager.SupabaseAnonKey}&vsn=1.0.0";
           
            RealtimeClient = new WebSocketPeer();
            Error err = RealtimeClient.ConnectToUrl(wsUrl);
           
            if (err != Error.Ok)
            {
                GD.PrintErr("❌ [RealtimeConnection] Supabase Realtime へのWebSocket接続初期化に失敗しました。");
                return;
            }

            IsListening = true;
            IsJoinedChannel = false;
            GD.Print($"🌐 [RealtimeConnection] Supabase Realtime 接続待機中 (Topic: {topicName})...");

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

                    string token = SessionManager.Instance.CurrentSession?.AccessToken;
                    if (string.IsNullOrEmpty(token))
                    {
                        token = SessionManager.SupabaseAnonKey;
                    }

                    var joinPayload = new
                    {
                        topic = topicName,
                        @event = "phx_join",
                        payload = new { 
                            access_token = token, 
                            config = new { 
                                postgres_changes = new[] { new { @event = "*", schema = "public", table = "lobbies" } },
                                broadcast = new { ack = false, self = true }
                            } 
                        },
                        @ref = currentRef
                    };
                    string joinJson = JsonSerializer.Serialize(joinPayload);
                    RealtimeClient.SendText(joinJson);
                    
                    IsJoinedChannel = true;
                    GD.Print($"📡 [RealtimeConnection] phx_join 送信完了 -> Topic: {topicName}, Ref: {currentRef}");
                }
                else
                {
                    GD.PrintErr($"❌ [RealtimeConnection] WebSocketがオープン状態になりませんでした。ReadyState: {RealtimeClient?.GetReadyState()}");
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

            if (RealtimeClient != null && RealtimeClient.GetReadyState() == WebSocketPeer.State.Open)
            {
                IsJoinedChannel = true;
                await Task.Delay(250);
                GD.Print("✅ [RealtimeConnection] EnsureConnectedAsync 完了");
                return true;
            }

            GD.PrintErr("⚠️ [RealtimeConnection] EnsureConnectedAsync タイムアウトしました");
            return false;
        }

        public static void StopListeningLobbyChanges()
        {
            RealtimeClient?.Close();
            RealtimeClient = null;

            IsListening = false;
            IsJoinedChannel = false;
            GD.Print("🛑 [RealtimeConnection] Supabase Realtime 監視を正常にクローズしました。");
        }
    }
}