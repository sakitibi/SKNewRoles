using Godot;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeBroadcaster
    {
        private static Node GetBroadcasterNode()
        {
            if (Engine.GetMainLoop() is SceneTree tree)
            {
                return tree.CurrentScene?.GetNode<Node>("RealtimeBroadcaster");
            }
            return null;
        }

        private static string GetTopicName()
        {
            string topic = RealtimeTopicProvider.GetCurrentTopic();
            if (string.IsNullOrEmpty(topic))
            {
                GD.PrintErr("[RealtimeBroadcaster] Error: Topic name is empty.");
                return "realtime:public:lobbies";
            }
            return topic;
        }

        /// <summary>
        /// プレイヤーの座標を送信します
        /// </summary>
        public static Task SendTransformAsync(RealtimeConnection connection, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            string senderId = SessionManager.Instance?.CurrentSession?.User?.Id ?? $"Guest_{SessionManager.Instance?.CurrentRoomCode}";

            Node node = GetBroadcasterNode();
            node?.Call("send_transform", connection.Client, topic, senderId, px, py, pz, rx, ry, rz);

            return Task.CompletedTask;
        }

        public static Task SendRoleAsync(RealtimeConnection connection, string targetPlayerId, uint role, uint faction)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            Node node = GetBroadcasterNode();
            node?.Call("send_role", connection.Client, topic, targetPlayerId, role, faction);

            return Task.CompletedTask;
        }

        public static Task SendHpAsync(RealtimeConnection connection, string playerId, uint currentHp, uint maxHp)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            Node node = GetBroadcasterNode();
            node?.Call("send_hp", connection.Client, topic, playerId, currentHp, maxHp);

            return Task.CompletedTask;
        }

        public static Task SendHungerAsync(RealtimeConnection connection, string playerId, uint currentHunger, uint maxHunger)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            Node node = GetBroadcasterNode();
            node?.Call("send_hunger", connection.Client, topic, playerId, currentHunger, maxHunger);

            return Task.CompletedTask;
        }

        public static Task SendHotbarSlotAsync(RealtimeConnection connection, string playerId, int slotIndex)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            Node node = GetBroadcasterNode();
            node?.Call("send_hotbar_slot", connection.Client, topic, playerId, slotIndex);

            return Task.CompletedTask;
        }

        public static Task SendHotbarItemAsync(RealtimeConnection connection, string playerId, int slotIndex, string itemId, ushort count)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            Node node = GetBroadcasterNode();
            node?.Call("send_hotbar_item", connection.Client, topic, playerId, slotIndex, itemId, count);

            return Task.CompletedTask;
        }

        public static Task SendAttackAsync(RealtimeConnection connection, string attackerId, string targetId, uint damage)
        {
            if (connection == null || !connection.IsJoinedChannel) return Task.CompletedTask;

            string topic = GetTopicName();
            Node node = GetBroadcasterNode();
            node?.Call("send_attack", connection.Client, topic, attackerId, targetId, damage);

            return Task.CompletedTask;
        }

        /// <summary>
        /// スキン情報を送信します
        /// </summary>
        public static async Task SendSkinAsync(RealtimeConnection connection, string playerId, Dictionary<string, string> skinPresets)
        {
            if (connection == null || !connection.IsJoinedChannel) return;

            string topic = GetTopicName();
            Godot.Collections.Dictionary<string, string> godotDict = new(skinPresets);
            
            Node node = GetBroadcasterNode();
            node?.Call("send_skin", connection.Client, topic, playerId, godotDict);

            await Task.CompletedTask;
        }
    }
}