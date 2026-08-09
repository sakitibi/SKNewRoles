using Godot;
using System;
using System.Diagnostics;
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

        // PING計測用の変数
        private readonly Stopwatch _pingStopwatch = new();
        private bool _isWaitingPong = false;
        private float _pingTimer = 0.0f;
        private const float PING_INTERVAL = 3.0f; // 3秒ごとにPING送信

        public WebSocketPeer Client => _client;
        public bool IsJoinedChannel => _isJoinedChannel;
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

                await Task.Delay(100);
                timeoutCounter++;
            }

            GD.PrintErr("⚠️ [Realtime] WebSocket 接続待機がタイムアウト(10秒)しました。");
            return false;
        }

        /// <summary>
        /// MainGameScene の _Process から毎フレーム呼ばれます（メインスレッド）
        /// </summary>
        public void Poll(double delta)
        {
            if (_client == null) return;

            var state = _client.GetReadyState();
            if (state != WebSocketPeer.State.Open) return;

            // 受信メッセージの処理
            _client.Poll();
            while (_client.GetAvailablePacketCount() > 0)
            {
                string message = _client.GetPacket().GetStringFromUtf8();
                ProcessMessageAndCheckPing(message);
            }

            // メインスレッドのタイマーで安全に PING を送信
            if (_isJoinedChannel)
            {
                _pingTimer += (float)delta;
                if (_pingTimer >= PING_INTERVAL)
                {
                    _pingTimer = 0.0f;
                    SendHeartbeat();
                }
            }
        }

        private void ProcessMessageAndCheckPing(string message)
        {
            if (string.IsNullOrEmpty(message)) return;

            // PING応答(phx_reply)受信時に PING 値を確定
            if (_isWaitingPong && message.Contains("phx_reply"))
            {
                _pingStopwatch.Stop();
                PingMs = (int)_pingStopwatch.ElapsedMilliseconds;
                _isWaitingPong = false;
            }

            // 通常のメッセージ配信（役職通知やTransform情報など）
            RealtimeMessageDispatcher.ProcessMessage(message, ref _isJoinedChannel);
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

        public void Close()
        {
            try
            {
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