using Godot;
using System;
using System.Threading;
using System.Threading.Tasks;
using System.Text.Json;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public class RealtimeConnection
    {
        private WebSocketPeer _client;
        private bool _isJoinedChannel = false;
        private int _refCounter = 1;

        private readonly CancellationTokenSource _cts = new();
        private readonly RealtimeMessageRouter _messageRouter = new();

        public WebSocketPeer Client => _client;
        public bool IsJoinedChannel => _isJoinedChannel;
        public int PingMs { get; private set; } = -1;

        // RealtimeMessageRouter へ各種イベントを委譲[cite: 2, 22]
        public event Action<string, string, uint> OnAttackReceived
        {
            add => _messageRouter.OnAttackReceived += value;
            remove => _messageRouter.OnAttackReceived -= value;
        }
        public event Action<string, float, float, float, float, float, float> OnTransformReceived
        {
            add => _messageRouter.OnTransformReceived += value;
            remove => _messageRouter.OnTransformReceived -= value;
        }
        public event Action<string, int, int> OnHpReceived
        {
            add => _messageRouter.OnHpReceived += value;
            remove => _messageRouter.OnHpReceived -= value;
        }
        public event Action<string, int, int> OnHungerReceived
        {
            add => _messageRouter.OnHungerReceived += value;
            remove => _messageRouter.OnHungerReceived -= value;
        }
        public event Action<string, int> OnHotbarSlotReceived
        {
            add => _messageRouter.OnHotbarSlotReceived += value;
            remove => _messageRouter.OnHotbarSlotReceived -= value;
        }
        public event Action<string, int, string, int> OnHotbarItemReceived
        {
            add => _messageRouter.OnHotbarItemReceived += value;
            remove => _messageRouter.OnHotbarItemReceived -= value;
        }
        public event Action<string, uint, uint> OnRoleAssignedReceived
        {
            add => _messageRouter.OnRoleAssignedReceived += value;
            remove => _messageRouter.OnRoleAssignedReceived -= value;
        }

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
                if (_cts.IsCancellationRequested) return false;

                _client.Poll();
                var state = _client.GetReadyState();

                if (state == WebSocketPeer.State.Open)
                {
                    if (!_isJoinedChannel && timeoutCounter % 10 == 0)
                    {
                        SendJoinChannelRequest();
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
                
                // 1. システムレベルの接続応答（phx_reply）の処理
                RealtimeMessageDispatcher.ProcessMessage(message, ref _isJoinedChannel);

                // 2. ゲーム内イベントメッセージのルーティング（パース＆イベント発火）
                _messageRouter.RouteMessage(message);
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

        public void Close()
        {
            try
            {
                _cts?.Cancel();

                if (_client != null && _client.GetReadyState() == WebSocketPeer.State.Open)
                {
                    _client.Close(1000, "Scene exit");
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] Close 時に例外が発生しました: {ex.Message}");
            }
            finally
            {
                _isJoinedChannel = false;
            }
        }
    }
}