using Godot;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeBroadcaster
    {
        public static async Task SendTransformAsync(RealtimeConnection connection, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (!IsReady(connection)) return;

            await Task.Run(() =>
            {
                string senderId = SessionManager.Instance?.CurrentSession?.User?.Id ?? $"Guest_{SessionManager.Instance?.CurrentRoomCode}";

                var payload = new
                {
                    topic = "realtime:public:lobbies",
                    @event = "broadcast",
                    payload = new { type = "transform_all", player_id = senderId, px, py, pz, rx, ry, rz },
                    @ref = (string)null
                };

                connection.Client.SendText(JsonSerializer.Serialize(payload));
            });
        }

        public static async Task SendRoleAsync(RealtimeConnection connection, string targetPlayerId, int role, int faction)
        {
            if (!IsReady(connection))
            {
                GD.PrintErr("❌ [Realtime] チャンネル参加が完了していないため SendRoleBroadcast を送信できませんでした。");
                return;
            }

            await Task.Run(() =>
            {
                var payload = new
                {
                    topic = "realtime:public:lobbies",
                    @event = "broadcast",
                    payload = new { type = "assign_role", target_player_id = targetPlayerId, role, faction },
                    @ref = (string)null
                };

                connection.Client.SendText(JsonSerializer.Serialize(payload));
                GD.Print($"📡 [Realtime] 役職データ送信成功: Target={targetPlayerId}, Role={role}, Faction={faction}");
            });
        }

        public static async Task SendHpAsync(RealtimeConnection connection, string playerId, int currentHp, int maxHp)
        {
            if (!IsReady(connection)) return;

            await Task.Run(() =>
            {
                var payload = new
                {
                    topic = "realtime:public:lobbies",
                    @event = "broadcast",
                    payload = new { type = "player_hp", player_id = playerId, current_hp = currentHp, max_hp = maxHp },
                    @ref = (string)null
                };

                connection.Client.SendText(JsonSerializer.Serialize(payload));
            });
        }

        public static async Task SendHotbarSlotAsync(RealtimeConnection connection, string playerId, int slotIndex)
        {
            if (!IsReady(connection)) return;

            await Task.Run(() =>
            {
                var payload = new
                {
                    topic = "realtime:public:lobbies",
                    @event = "broadcast",
                    payload = new { type = "hotbar_slot", player_id = playerId, slot_index = slotIndex },
                    @ref = (string)null
                };

                connection.Client.SendText(JsonSerializer.Serialize(payload));
            });
        }

        public static async Task SendHotbarItemAsync(RealtimeConnection connection, string playerId, int slotIndex, int itemId, int count)
        {
            if (!IsReady(connection)) return;

            await Task.Run(() =>
            {
                var payload = new
                {
                    topic = "realtime:public:lobbies",
                    @event = "broadcast",
                    payload = new { type = "hotbar_item", player_id = playerId, slot_index = slotIndex, item_id = itemId, count },
                    @ref = (string)null
                };

                connection.Client.SendText(JsonSerializer.Serialize(payload));
            });
        }

        private static bool IsReady(RealtimeConnection connection)
        {
            return connection?.Client != null && 
                   connection.Client.GetReadyState() == WebSocketPeer.State.Open && 
                   connection.IsJoinedChannel;
        }
    }
}