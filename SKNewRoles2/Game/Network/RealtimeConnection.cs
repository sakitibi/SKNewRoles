using Godot;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public class RealtimeConnection : IDisposable
    {
        private readonly GodotObject _cppConnection;
        private int _refCounter = 1;
        private readonly CancellationTokenSource _cts = new();
        private readonly RealtimeMessageRouter _messageRouter = new();
        private bool _disposed = false;

        public WebSocketPeer Client => _cppConnection?.Call("get_client").As<WebSocketPeer>();
        public GodotObject CppObject => _cppConnection;

        public bool IsJoinedChannel
        {
            get => _cppConnection != null && _cppConnection.Call("is_joined_channel").AsBool();
            private set => _cppConnection?.Call("set_joined_channel", value);
        }

        public int PingMs { get; private set; } = -1;

        // --- 受信イベントのブリッジ ---
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

        public event Action<string, Dictionary<string, string>> OnSkinReceived
        {
            add => _messageRouter.OnSkinReceived += value;
            remove => _messageRouter.OnSkinReceived -= value;
        }

        public RealtimeConnection()
        {
            try
            {
                _cppConnection = (GodotObject)ClassDB.Instantiate("RealtimeConnection");
                if (_cppConnection == null)
                {
                    GD.PrintErr("❌ [RealtimeConnection] C++製 RealtimeConnection のインスタンス化に失敗しました。");
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ [RealtimeConnection] 例外発生: {ex.Message}");
            }
        }

        public async Task<bool> EnsureConnectedAsync()
        {
            if (_cppConnection == null) return false;

            long currentState = _cppConnection.Call("get_ready_state").AsInt64();
            if (currentState == (long)WebSocketPeer.State.Open && IsJoinedChannel) return true;

            if (string.IsNullOrEmpty(SessionManager.SupabaseUrl) || string.IsNullOrEmpty(SessionManager.SupabaseAnonKey))
            {
                GD.PrintErr("❌ [Realtime] Supabase の設定が不足しています。");
                return false;
            }

            string wsUrl = $"{SessionManager.SupabaseUrl.Replace("https://", "wss://")}/realtime/v1/websocket?apikey={SessionManager.SupabaseAnonKey}";
            Error err = (Error)_cppConnection.Call("connect_to_url", wsUrl).AsInt32();

            if (err != Error.Ok)
            {
                GD.PrintErr($"❌ [Realtime] 接続初期化失敗: {err}");
                return false;
            }

            IsJoinedChannel = false;
            GD.Print("🌐 [Realtime] WebSocket 接続を開始しました。");

            int timeoutCounter = 0;
            while (timeoutCounter < 100)
            {
                if (_cts.IsCancellationRequested) return false;

                _cppConnection.Call("poll");
                long state = _cppConnection.Call("get_ready_state").AsInt64();

                if (state == (long)WebSocketPeer.State.Open)
                {
                    if (!IsJoinedChannel && timeoutCounter % 10 == 0)
                    {
                        string topicName = RealtimeTopicProvider.GetCurrentTopic();
                        _cppConnection.Call("send_join_channel", topicName, _refCounter++.ToString());
                    }

                    if (IsJoinedChannel)
                    {
                        GD.Print("✅ [Realtime] チャンネル参加完了！");
                        return true;
                    }
                }
                else if (state == (long)WebSocketPeer.State.Closed)
                {
                    GD.PrintErr("❌ [Realtime] 接続が切断されました。");
                    return false;
                }

                await Task.Delay(100);
                timeoutCounter++;
            }

            GD.PrintErr("⚠️ [Realtime] 接続待機タイムアウト。");
            return false;
        }

        public void Poll()
        {
            if (_cppConnection == null) return;

            _cppConnection.Call("poll");
            long state = _cppConnection.Call("get_ready_state").AsInt64();
            if (state != (long)WebSocketPeer.State.Open) return;

            long packetCount = _cppConnection.Call("get_available_packet_count").AsInt64();
            while (packetCount > 0)
            {
                string message = _cppConnection.Call("get_next_packet_string").AsString();
                if (!string.IsNullOrEmpty(message))
                {
                    bool joined = IsJoinedChannel;
                    RealtimeMessageDispatcher.ProcessMessage(message, ref joined);
                    IsJoinedChannel = joined;

                    _messageRouter.RouteMessage(message);
                }
                packetCount = _cppConnection.Call("get_available_packet_count").AsInt64();
            }
        }

        public void Close()
        {
            if (_disposed) return;
            try
            {
                _cts?.Cancel();
                Client?.Close(1000, "Scene exit");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] Close 例外: {ex.Message}");
            }
            finally
            {
                IsJoinedChannel = false;
            }
        }

        public void Dispose()
        {
            if (_disposed) return;
            Close();
            _cts?.Dispose();
            _disposed = true;
            GC.SuppressFinalize(this);
        }
    }
}