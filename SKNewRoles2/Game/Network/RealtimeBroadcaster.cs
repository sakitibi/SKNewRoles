using Godot;
using System.Collections.Generic;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeBroadcaster
    {
        private static Vector3 _lastSentPosition = Vector3.Zero;
        private static Vector3 _lastSentRotation = Vector3.Zero;
        private static ulong _lastSendTick = 0;
        private const ulong SendIntervalMs = 300;
        private const float PosThreshold = 0.02f;
        private const float RotThreshold = 0.02f;

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
            if (!IsReady(connection)) return Task.CompletedTask;

            ulong currentTick = Time.GetTicksMsec();
            if (currentTick - _lastSendTick < SendIntervalMs)
            {
                return Task.CompletedTask;
            }

            Vector3 currentPos = new(px, py, pz);
            Vector3 currentRot = new(rx, ry, rz);

            bool hasMoved = currentPos.DistanceSquaredTo(_lastSentPosition) > (PosThreshold * PosThreshold);
            bool hasRotated = currentRot.DistanceSquaredTo(_lastSentRotation) > (RotThreshold * RotThreshold);

            if (!hasMoved && !hasRotated)
            {
                return Task.CompletedTask;
            }

            _lastSentPosition = currentPos;
            _lastSentRotation = currentRot;
            _lastSendTick = currentTick;

            string senderId = SessionManager.Instance?.CurrentSession?.User?.Id ?? $"Guest_{SessionManager.Instance?.CurrentRoomCode}";

            RealtimePayload payload = new()
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "transform_all", player_id = senderId, px, py, pz, rx, ry, rz },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendRoleAsync(RealtimeConnection connection, string targetPlayerId, uint role, uint faction)
        {
            if (!IsReady(connection))
            {
                GD.PrintErr("[Realtime] Error: Channel join is not completed, cannot send role.");
                return Task.CompletedTask;
            }

            string currentTopic = GetTopicName();
            GD.Print($"[Realtime] Sending role data: Topic={currentTopic}, Target={targetPlayerId}, Role={role}");

            RealtimePayload payload = new()
            {
                topic = currentTopic,
                @event = "broadcast",
                payload = new { type = "assign_role", target_player_id = targetPlayerId, role, faction },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            GD.Print($"[Realtime] Role data sent successfully: Target={targetPlayerId}, Role={role}");
            return Task.CompletedTask;
        }

        public static Task SendHpAsync(RealtimeConnection connection, string playerId, uint currentHp, uint maxHp)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            RealtimePayload payload = new()
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "player_hp", player_id = playerId, current_hp = currentHp, max_hp = maxHp },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendHungerAsync(RealtimeConnection connection, string playerId, uint currentHunger, uint maxHunger)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            RealtimePayload payloadObj = new()
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "player_hunger", player_id = playerId, current_hunger = currentHunger, max_hunger = maxHunger },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payloadObj));
            return Task.CompletedTask;
        }

        public static Task SendHotbarSlotAsync(RealtimeConnection connection, string playerId, int slotIndex)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            RealtimePayload payload = new()
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "hotbar_slot", player_id = playerId, slot_index = slotIndex },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendHotbarItemAsync(RealtimeConnection connection, string playerId, int slotIndex, string itemId, ushort count)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            RealtimePayload payload = new()
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "hotbar_item", player_id = playerId, slot_index = slotIndex, item_id = itemId, count },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        public static Task SendAttackAsync(RealtimeConnection connection, string attackerId, string targetId, uint damage)
        {
            if (!IsReady(connection)) return Task.CompletedTask;

            RealtimePayload payload = new()
            {
                topic = GetTopicName(),
                @event = "broadcast",
                payload = new { type = "player_attack", attacker_id = attackerId, target_id = targetId, damage },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            return Task.CompletedTask;
        }

        /// <summary>
        /// スキン情報を送信します
        /// </summary>
        public static async Task SendSkinAsync(RealtimeConnection connection, string playerId, Dictionary<string, string> skinPresets)
        {
            int retryCount = 0;
            while (!IsReady(connection) && retryCount < 20)
            {
                await Task.Delay(500);
                retryCount++;
            }

            if (!IsReady(connection))
            {
                GD.PrintErr("[RealtimeBroadcaster] Error: Failed to send skin because connection is not ready after timeout.");
                return;
            }

            string currentTopic = GetTopicName();
            RealtimePayload payload = new()
            {
                topic = currentTopic,
                @event = "broadcast",
                payload = new { type = "player_skin", player_id = playerId, skins = skinPresets },
                @ref = null
            };

            connection.Client.SendText(JsonSerializer.Serialize(payload));
            GD.Print($"[RealtimeBroadcaster] Skin data sent successfully for player: {playerId}");
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