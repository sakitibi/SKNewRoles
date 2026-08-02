using System;

namespace SKNewRoles2.Lobby.JOIN.Services.Realtime
{
    public static class RealtimeEvents
    {
        public static event Action OnLobbyTableChanged;
        public static event Action<string, float, float, float, float, float, float> OnPlayerTransformReceivedAll; 
        public static event Action<string, int, int> OnRoleAssignedReceived;

        public static void RaiseLobbyTableChanged() 
            => OnLobbyTableChanged?.Invoke();

        public static void RaisePlayerTransformReceivedAll(string pId, float px, float py, float pz, float rx, float ry, float rz) 
            => OnPlayerTransformReceivedAll?.Invoke(pId, px, py, pz, rx, ry, rz);

        public static void RaiseRoleAssignedReceived(string targetPlayerId, int role, int faction) 
            => OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);
    }
}