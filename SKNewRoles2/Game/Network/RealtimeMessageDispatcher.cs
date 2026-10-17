using Godot;
using System;
using System.Text.Json;

namespace SKNewRoles2.Game.Network
{
    public static class RealtimeMessageDispatcher
    {
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
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [RealtimeMessageDispatcher] パース例外: {ex.Message}");
            }
        }
    }
}