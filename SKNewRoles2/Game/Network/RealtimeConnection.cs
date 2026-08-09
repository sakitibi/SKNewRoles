using Godot;
using System;
using System.Diagnostics;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public class RealtimeConnection
    {
        private WebSocketPeer _client;
        private bool _isJoinedChannel = false;
        private int _refCounter = 1;

        // PING計測用の変数
        private readonly Stopwatch _pingStopwatch = new();
        private bool _isWaitingPong = false;

        // シーン遷移時などの非同期処理キャンセル用トークン
        private CancellationTokenSource _cts = new();

        public WebSocketPeer Client => _client;
        public bool IsJoinedChannel => _isJoinedChannel;

        /// <summary>
        /// 直近で計測された PING (ms) の値。未計測時は -1
        /// </summary>
        public int PingMs { get; private set; } = -1;

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
            while (timeoutCounter < 100 && !_cts.Token.IsCancellationRequested)
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
                        ProcessMessageAndCheckPing(message);
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

                await Task.Delay(100, _cts.Token).ContinueWith(_ => { });
                timeoutCounter++;
            }

            GD.PrintErr("⚠️ [Realtime] WebSocket 接続待機がタイムアウト(10秒)またはキャンセルされました。");
            return false;
        }

        public void Poll()
        {
            if (_client == null || _cts.IsCancellationRequested) return;

            _client.Poll();
            while (_client.GetAvailablePacketCount() > 0)
            {
                string message = _client.GetPacket().GetStringFromUtf8();
                ProcessMessageAndCheckPing(message);
            }
        }

        private void ProcessMessageAndCheckPing(string message)
        {
            RealtimeMessageDispatcher.ProcessMessage(message, ref _isJoinedChannel);

            // Phoenix Channel の Heartbeat 応答(phx_reply)受信時に PING 計測完了
            if (_isWaitingPong && message.Contains("phx_reply"))
            {
                _pingStopwatch.Stop();
                PingMs = (int)_pingStopwatch.ElapsedMilliseconds;
                _isWaitingPong = false;
            }
        }

        /// <summary>
        /// 定期的に PING (Heartbeat) を送信して応答時間を測定します。
        /// </summary>
        public async Task StartPingLoopAsync()
        {
            try
            {
                while (_client != null && 
                       _client.GetReadyState() == WebSocketPeer.State.Open && 
                       !_cts.Token.IsCancellationRequested)
                {
                    SendHeartbeat();
                    await Task.Delay(3000, _cts.Token); // 3秒周期で計測
                }
            }
            catch (TaskCanceledException)
            {
                // シーン離脱によるキャンセルの場合は正常終了
            }
        }

        private void SendHeartbeat()
        {
            if (_client == null || _client.GetReadyState() != WebSocketPeer.State.Open) return;

            _pingStopwatch.Restart();
            _isWaitingPong = true;

            var heartbeatPayload = new
            {
                topic = "phoenix",
                @event = "heartbeat",
                payload = new { },
                @ref = _refCounter++.ToString()
            };

            _client.SendText(JsonSerializer.Serialize(heartbeatPayload));
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

        /// <summary>
        /// シーン破棄時などに非同期処理とWebSocket接続を安全に終了させます。
        /// </summary>
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