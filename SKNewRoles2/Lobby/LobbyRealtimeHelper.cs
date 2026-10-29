using Godot;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;
using System;

namespace SKNewRoles2.Lobby
{
    public static class LobbyRealtimeHelper
    {
        private static Vector3 _lastSentPosition = Vector3.Zero;
        private static Vector3 _lastSentRotation = Vector3.Zero;

        public static void RegisterListeners(
            Action onTableChanged, 
            Action<string, float, float, float, float, float, float> onTransformReceived)
        {
            RealtimeEvents.OnLobbyTableChanged -= onTableChanged;
            RealtimeEvents.OnLobbyTableChanged += onTableChanged;

            if (onTransformReceived != null)
            {
                RealtimeEvents.OnPlayerTransformReceivedAll -= onTransformReceived;
                RealtimeEvents.OnPlayerTransformReceivedAll += onTransformReceived;
            }

            RealtimeConnectionService.StartListeningLobbyChanges();
        }

        public static void UnregisterListeners(
            Action onTableChanged, 
            Action<string, float, float, float, float, float, float> onTransformReceived)
        {
            RealtimeEvents.OnLobbyTableChanged -= onTableChanged;

            if (onTransformReceived != null)
            {
                RealtimeEvents.OnPlayerTransformReceivedAll -= onTransformReceived;
            }

            RealtimeConnectionService.StopListeningLobbyChanges();
        }

        public static void UpdatePlayerTransformBroadcast(Node3D targetNode, ref float broadcastTimer, float delta, float interval = 0.3f)
        {
            if (targetNode == null || !GodotObject.IsInstanceValid(targetNode)) return;

            broadcastTimer += delta;
            if (broadcastTimer >= interval)
            {
                broadcastTimer = 0.0f;

                Vector3 currentPos = targetNode.Position;
                Vector3 currentRot = targetNode.Rotation;

                float posThreshold = 0.02f; 
                float rotThreshold = 0.02f;

                bool hasMoved = currentPos.DistanceSquaredTo(_lastSentPosition) > (posThreshold * posThreshold);
                bool hasRotated = currentRot.DistanceSquaredTo(_lastSentRotation) > (rotThreshold * rotThreshold);

                if (hasMoved || hasRotated)
                {
                    _lastSentPosition = currentPos;
                    _lastSentRotation = currentRot;

                    RealtimeLobbySender.LobbySendTransformBroadcastAll(
                        currentPos.X,
                        currentPos.Y,
                        currentPos.Z,
                        currentRot.X,
                        currentRot.Y,
                        currentRot.Z
                    );
                }
            }
        }
    }
}