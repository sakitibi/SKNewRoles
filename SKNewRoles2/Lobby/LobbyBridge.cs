using Godot;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;

namespace SKNewRoles2.Lobby
{
    public partial class LobbyBridge : Node
    {
        private GodotObject _cppLobbyManager;
        private float _broadcastTimer = 0.0f;
        private const float BroadcastInterval = 0.1f;

        public override void _Ready()
        {
            _cppLobbyManager = GetParent(); 

            RealtimeEvents.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;
            GD.Print("🌁 LobbyBridge: C++へのフル3Dトランスフォーム仲介システムが正常に起動しました。");
        }

        public override void _ExitTree()
        {
            RealtimeEvents.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
        }

        public override void _Process(double delta)
        {
            RealtimeLobbyReceiver.PollRealtimeEvents();

            _broadcastTimer += (float)delta;
            if (_broadcastTimer >= BroadcastInterval)
            {
                _broadcastTimer = 0.0f;

                if (_cppLobbyManager is Node3D lobbyNode3D)
                {
                    var myPlayer = lobbyNode3D.GetNode<Node3D>("MyPlayer");
                    if (myPlayer != null && IsInstanceValid(myPlayer))
                    {
                        RealtimeLobbySender.LobbySendTransformBroadcastAll(
                            myPlayer.Position.X,
                            myPlayer.Position.Y,
                            myPlayer.Position.Z,
                            myPlayer.Rotation.X,
                            myPlayer.Rotation.Y,
                            myPlayer.Rotation.Z
                        );
                    }
                }
            }
        }

        private void OnPlayerTransformReceivedAll(string playerId, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (_cppLobbyManager != null && IsInstanceValid(_cppLobbyManager))
            {
                if (_cppLobbyManager.HasMethod("update_remote_player_transform"))
                {
                    _cppLobbyManager.Call("update_remote_player_transform", playerId, px, py, pz, rx, ry, rz);
                }
            }
        }
    }
}