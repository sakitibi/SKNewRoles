using Godot;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeBroadcaster
    {
        private static string GetTopicName()
        {
            string topic = RealtimeBroadcastService.GetCurrentTopic();
            if (string.IsNullOrEmpty(topic))
            {
                GD.PrintErr("⚠️ [RealtimeBroadcaster] 取得したトピック名が空です！");
                return "realtime:public:lobbies";
            }
            return topic;
        }

        public static Task SendTransformAsync(RealtimeConnection connection, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            string senderId = SessionManager.Instance?.CurrentSession?.User?.Id ?? $"Guest_{SessionManager.Instance?.CurrentRoomCode}";

            var payload = new
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "transform_all", player_id = senderId, px, py, pz, rx, ry, rz },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendRoleAsync(RealtimeConnection connection, string targetPlayerId, uint role, uint faction)
        {
            if (!IsReady(connection))
            {
                GD.PrintErr("❌ [Realtime] チャンネル参加が完了していないため SendRoleAsync を送信できませんでした。");
                return Task.CompletedTask;
            }

            string currentTopic = GetTopicName();
            GD.Print($"📡 [Realtime] 送信トピック確認: {currentTopic} (Target={targetPlayerId}, Role={role})");

            var payload = new
            {
                topic = currentTopic,
                @event = "broadcast",
                payload = new { type = "assign_role", target_player_id = targetPlayerId, role, faction },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            GD.Print($"📡 [Realtime] 役職データ送信成功: Target={targetPlayerId}, Role={role}, Faction={faction}");
            return Task.CompletedTask;
        }

        public static Task SendHpAsync(RealtimeConnection connection, string playerId, uint currentHp, uint maxHp)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            var payload = new
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "player_hp", player_id = playerId, current_hp = currentHp, max_hp = maxHp },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendHungerAsync(RealtimeConnection connection, string playerId, uint currentHunger, uint maxHunger)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            var payloadObj = new
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "player_hunger", player_id = playerId, current_hunger = currentHunger, max_hunger = maxHunger },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payloadObj));
            return Task.CompletedTask;
        }

        public static Task SendHotbarSlotAsync(RealtimeConnection connection, string playerId, int slotIndex)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            var payload = new
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "hotbar_slot", player_id = playerId, slot_index = slotIndex },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendHotbarItemAsync(RealtimeConnection connection, string playerId, int slotIndex, string itemId, ushort count)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            var payload = new
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "hotbar_item", player_id = playerId, slot_index = slotIndex, item_id = itemId, count },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendAttackAsync(RealtimeConnection connection, string attackerId, string targetId, uint damage)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            var payload = new
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "player_attack", attacker_id = attackerId, target_id = targetId, damage },
                @ref = (string)null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        private static bool IsReady(RealtimeConnection connection)
        {
            return connection != null && 
                   connection.Client != null && 
                   connection.Client.GetReadyState() == WebSocketPeer.State.Open && 
                   connection.IsJoinedChannel;
        }
    }
}