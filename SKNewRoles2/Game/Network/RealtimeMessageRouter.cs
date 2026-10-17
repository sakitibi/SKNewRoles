using Godot;
using System;
using System.Text.Json;

namespace SKNewRoles2.Game.Network
{
    public class RealtimeMessageRouter
    {
        public event Action<string, string, uint> OnAttackReceived;
        public event Action<string, float, float, float, float, float, float> OnTransformReceived;
        public event Action<string, int, int> OnHpReceived;
        public event Action<string, int, int> OnHungerReceived;
        public event Action<string, int> OnHotbarSlotReceived;
        public event Action<string, int, string, int> OnHotbarItemReceived;
        public event Action<string, uint, uint> OnRoleAssignedReceived;

        public void RouteMessage(string message)
        {
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
                GD.PrintErr($"⚠️ [RealtimeMessageRouter] パース例外: {ex.Message}");
            }
        }
    }
}