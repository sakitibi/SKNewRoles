using System;
using System.Collections.Generic;

namespace SKNewRoles2.Lobby.JOIN.Services.Realtime
{
    public static class RealtimeEvents
    {
        public static event Action OnLobbyTableChanged;
        public static event Action<string, float, float, float, float, float, float> OnPlayerTransformReceivedAll; 
        public static event Action<string, int, int> OnRoleAssignedReceived;
        public static event Action OnGameStartReceived;
        public static event Action<string> OnPlayerLeaveReceived;
        public static event Action<string, Dictionary<string, string>> OnPlayerSkinReceived;

        public static void RaiseLobbyTableChanged() 
            => OnLobbyTableChanged?.Invoke();

        public static void RaisePlayerTransformReceivedAll(string pId, float px, float py, float pz, float rx, float ry, float rz) 
            => OnPlayerTransformReceivedAll?.Invoke(pId, px, py, pz, rx, ry, rz);

        public static void RaiseRoleAssignedReceived(string targetPlayerId, int role, int faction) 
            => OnRoleAssignedReceived?.Invoke(targetPlayerId, role, faction);

        public static void RaiseGameStartReceived() 
            => OnGameStartReceived?.Invoke();
        
        public static void RaisePlayerLeaveReceived(string playerId)
            => OnPlayerLeaveReceived?.Invoke(playerId);

        public static void RaisePlayerSkinReceived(string playerId, Dictionary<string, string> skins)
            => OnPlayerSkinReceived?.Invoke(playerId, skins);
    }
}