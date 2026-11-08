using Godot;
using System;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game.Player.Handler
{
    public class PlayerTransformSyncHandler(MainGameScene scene)
    {
        private Vector3 _lastSentPosition = Vector3.Zero;
        private Vector3 _lastSentRotation = Vector3.Zero;

        public void ProcessMovementSync()
        {
            Node3D player = scene.MyPlayerInstance;
            if (player != null && GodotObject.IsInstanceValid(player) && player.Visible)
            {
                Vector3 playerPos = player.GlobalPosition;
                Vector3 playerRot = player.Rotation;

                float posThreshold = 0.001f;
                float rotThreshold = 0.001f;

                bool hasMoved = playerPos.DistanceSquaredTo(_lastSentPosition) > (posThreshold * posThreshold);
                bool hasRotated = playerRot.DistanceSquaredTo(_lastSentRotation) > (rotThreshold * rotThreshold);

                if (hasMoved || hasRotated)
                {
                    _lastSentPosition = playerPos;
                    _lastSentRotation = playerRot;
                    SendMyTransform();
                }
            }
        }

        public void SendMyTransform()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance)) return;

            Vector3 pos = scene.MyPlayerInstance.GlobalPosition;
            Vector3 rot = scene.MyPlayerInstance.Rotation;

            try
            {
                _ = RealtimeBroadcaster.SendTransformAsync(scene.Connection, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending transform: {ex.Message}");
            }
        }
    }
}