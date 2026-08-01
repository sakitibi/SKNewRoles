using Godot;
using System;
using System.Text.Json;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeMessageDispatcher
    {
        public static event Action<string, float, float, float, float, float, float> OnPlayerTransformReceivedAll;
        public static event Action<string, int, int> OnRoleAssignedReceived;
        public static event Action<string, int, int> OnPlayerHpReceived;

        public static void ProcessMessage(string rawJson, ref bool isJoinedChannel)
        {
            try
            {
                using var doc = JsonDocument.Parse(rawJson);
                var root = doc.RootElement;

                if (!root.TryGetProperty("event", out var eventProp)) return;

                string eventName = eventProp.GetString();

                if (eventName == "phx_reply")
                {
                    if (root.TryGetProperty("payload", out var payloadProp) &&
                        payloadProp.TryGetProperty("status", out var statusProp) &&
                        statusProp.GetString() == "ok")
                    {
                        isJoinedChannel = true;
                    }
                }
                else if (eventName == "broadcast")
                {
                    if (!root.TryGetProperty("payload", out var payloadProp)) return;
                    if (!payloadProp.TryGetProperty("type", out var typeProp)) return;

                    string type = typeProp.GetString();

                    if (type == "transform_all")
                    {
                        string senderId = payloadProp.GetProperty("player_id").GetString();
                        float px = payloadProp.GetProperty("px").GetSingle();
                        float py = payloadProp.GetProperty("py").GetSingle();
                        float pz = payloadProp.GetProperty("pz").GetSingle();
                        float rx = payloadProp.GetProperty("rx").GetSingle();
                        float ry = payloadProp.GetProperty("ry").GetSingle();
                        float rz = payloadProp.GetProperty("rz").GetSingle();

                        OnPlayerTransformReceivedAll?.Invoke(senderId, px, py, pz, rx, ry, rz);
                    }
                    else if (type == "assign_role")
                    {
                        string targetPlayerId = payloadProp.GetProperty("target_player_id").GetString();
                        int role = payloadProp.GetProperty("role").GetInt32();
                        int faction = payloadProp.GetProperty("faction").GetInt32();

                        OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);
                    }
                    else if (type == "player_hp")
                    {
                        string playerId = payloadProp.GetProperty("player_id").GetString();
                        int currentHp = payloadProp.GetProperty("current_hp").GetInt32();
                        int maxHp = payloadProp.GetProperty("max_hp").GetInt32();

                        OnPlayerHpReceived?.Invoke(playerId, currentHp, maxHp);
                    }
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] JSON 解析エラー: {ex.Message}");
            }
        }
    }
}