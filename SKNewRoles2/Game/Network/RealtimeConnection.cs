using Godot;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public class RealtimeConnection
    {
        private WebSocketPeer _client;
        private bool _isJoinedChannel = false;
        private int _refCounter = 1;

        public WebSocketPeer Client => _client;
        public bool IsJoinedChannel => _isJoinedChannel;

        public async Task<bool> EnsureConnectedAsync()
        {
            if (_client != null && 
                _client.GetReadyState() == WebSocketPeer.State.Open && 
                _isJoinedChannel)
            {
                return true;
            }

            string wsUrl = $"{SessionManager.SupabaseUrl.Replace("https://", "wss://")}/realtime/v1/websocket?apikey={SessionManager.SupabaseAnonKey}";
            
            _client = new WebSocketPeer();
            Error err = _client.ConnectToUrl(wsUrl);

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
                _client.Poll();
                var state = _client.GetReadyState();

                if (state == WebSocketPeer.State.Open)
                {
                    if (!_isJoinedChannel)
                    {
                        SendJoinChannelRequest();
                    }

                    while (_client.GetAvailablePacketCount() > 0)
                    {
                        string message = _client.GetPacket().GetStringFromUtf8();
                        RealtimeMessageDispatcher.ProcessMessage(message, ref _isJoinedChannel);
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

        public void Poll()
        {
            if (_client == null) return;

            _client.Poll();
            while (_client.GetAvailablePacketCount() > 0)
            {
                string message = _client.GetPacket().GetStringFromUtf8();
                RealtimeMessageDispatcher.ProcessMessage(message, ref _isJoinedChannel);
            }
        }

        private void SendJoinChannelRequest()
        {
            var joinPayload = new
            {
                topic = "realtime:public:lobbies",
                @event = "phx_join",
                payload = new { config = new { broadcast = new { self = false } } },
                @ref = _refCounter++.ToString()
            };

            _client.SendText(JsonSerializer.Serialize(joinPayload));
            GD.Print("📡 [Realtime] phx_join リクエストを送信しました。");
        }
    }
}