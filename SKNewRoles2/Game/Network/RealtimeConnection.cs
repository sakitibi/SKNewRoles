using Godot;
using System;
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

        private readonly CancellationTokenSource _cts = new();

        public WebSocketPeer Client => _client;
        public bool IsJoinedChannel => _isJoinedChannel;

        public int PingMs { get; private set; } = -1;

        // 各種イベントの定義
        public event Action<string, string, uint> OnAttackReceived;
        public event Action<string, float, float, float, float, float, float> OnTransformReceived;
        public event Action<string, int, int> OnHpReceived;
        public event Action<string, int, int> OnHungerReceived;
        public event Action<string, int> OnHotbarSlotReceived;
        public event Action<string, int, string, int> OnHotbarItemReceived;
        public event Action<string, uint, uint> OnRoleAssignedReceived;

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
                
                try
                {
                    using JsonDocument doc = JsonDocument.Parse(message);
                    JsonElement root = doc.RootElement;

                    if (root.TryGetProperty("event", out JsonElement evElem) && evElem.GetString() == "broadcast")
                    {
                        JsonElement payload = root.GetProperty("payload");
                        if (payload.TryGetProperty("type", out JsonElement typeElem))
                        {
                            string type = typeElem.GetString();

                            switch (type)
                            {
                                case "player_attack":
                                {
                                    string attackerId = payload.GetProperty("attacker_id").GetString();
                                    string targetId = payload.GetProperty("target_id").GetString();
                                    uint damage = payload.GetProperty("damage").GetUInt32();
                                    OnAttackReceived?.Invoke(attackerId, targetId, damage);
                                    break;
                                }
                                case "transform_all":
                                {
                                    string playerId = payload.GetProperty("player_id").GetString();
                                    float px = (float)payload.GetProperty("px").GetDouble();
                                    float py = (float)payload.GetProperty("py").GetDouble();
                                    float pz = (float)payload.GetProperty("pz").GetDouble();
                                    float rx = (float)payload.GetProperty("rx").GetDouble();
                                    float ry = (float)payload.GetProperty("ry").GetDouble();
                                    float rz = (float)payload.GetProperty("rz").GetDouble();
                                    OnTransformReceived?.Invoke(playerId, px, py, pz, rx, ry, rz);
                                    break;
                                }
                                case "player_hp":
                                {
                                    string playerId = payload.GetProperty("player_id").GetString();
                                    int currentHp = payload.GetProperty("current_hp").GetInt32();
                                    int maxHp = payload.GetProperty("max_hp").GetInt32();
                                    OnHpReceived?.Invoke(playerId, currentHp, maxHp);
                                    break;
                                }
                                case "player_hunger":
                                {
                                    string playerId = payload.GetProperty("player_id").GetString();
                                    int currentHunger = payload.GetProperty("current_hunger").GetInt32();
                                    int maxHunger = payload.GetProperty("max_hunger").GetInt32();
                                    OnHungerReceived?.Invoke(playerId, currentHunger, maxHunger);
                                    break;
                                }
                                case "hotbar_slot":
                                {
                                    string playerId = payload.GetProperty("player_id").GetString();
                                    int slotIndex = payload.GetProperty("slot_index").GetInt32();
                                    OnHotbarSlotReceived?.Invoke(playerId, slotIndex);
                                    break;
                                }
                                case "hotbar_item":
                                {
                                    string playerId = payload.GetProperty("player_id").GetString();
                                    int slotIndex = payload.GetProperty("slot_index").GetInt32();
                                    string itemId = payload.GetProperty("item_id").GetString();
                                    int count = payload.GetProperty("count").GetInt32();
                                    OnHotbarItemReceived?.Invoke(playerId, slotIndex, itemId, count);
                                    break;
                                }
                                case "assign_role":
                                {
                                    string targetPlayerId = payload.GetProperty("target_player_id").GetString();
                                    uint role = payload.GetProperty("role").GetUInt32();
                                    uint faction = payload.GetProperty("faction").GetUInt32();
                                    OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);
                                    break;
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    GD.PrintErr($"⚠️ [RealtimeConnection] パース例外: {ex.Message}");
                }

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