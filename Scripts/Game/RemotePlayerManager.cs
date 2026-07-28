using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class RemotePlayerManager : Node
    {
        private PackedScene _opponentScene;
        private Dictionary<string, Node3D> _otherPlayers = new Dictionary<string, Node3D>();
        private string _myUserId;

        public void Initialize(PackedScene opponentScene, string myUserId)
        {
            _opponentScene = opponentScene;
            _myUserId = myUserId;

            Realtime.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;
            Realtime.OnPlayerHpReceived += OnOtherPlayerHpReceived;
        }

        private void OnPlayerTransformReceivedAll(string senderId, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (senderId == _myUserId) return;

            if (!_otherPlayers.ContainsKey(senderId))
            {
                if (_opponentScene == null) return;

                Node3D remotePlayer = _opponentScene.Instantiate<Node3D>();
                remotePlayer.Name = $"RemotePlayer_{senderId}";
                AddChild(remotePlayer);
                _otherPlayers[senderId] = remotePlayer;
            }

            Node3D targetPlayer = _otherPlayers[senderId];
            if (targetPlayer != null)
            {
                if (targetPlayer.HasMethod("set_target_transform"))
                {
                    targetPlayer.Call("set_target_transform", px, py, pz, rx, ry, rz);
                }
                else
                {
                    targetPlayer.GlobalPosition = new Vector3(px, py, pz);
                    targetPlayer.Rotation = new Vector3(rx, ry, rz);
                }
            }
        }

        private void OnOtherPlayerHpReceived(string senderId, int currentHp, int maxHp)
        {
            if (senderId == _myUserId) return;

            if (_otherPlayers.TryGetValue(senderId, out Node3D remotePlayer))
            {
                if (IsInstanceValid(remotePlayer) && remotePlayer.HasMethod("set_current_hp"))
                {
                    remotePlayer.Call("set_current_hp", currentHp);
                }
            }
        }

        public override void _ExitTree()
        {
            Realtime.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
            Realtime.OnPlayerHpReceived -= OnOtherPlayerHpReceived;
        }
    }
}