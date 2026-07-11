using Godot;
using SKNewRoles2.Lobby.JOIN;

namespace SKNewRoles2.Lobby
{
    // GDExtensionで登録された「LobbyManager (C++)」ノード、またはその子ノードにアタッチするスクリプト
    public partial class LobbyBridge : Node
    {
        private GodotObject _cppLobbyManager;

        public override void _Ready()
        {
            _cppLobbyManager = GetParent(); 

            LobbyRealtime.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;
            GD.Print("🌁 LobbyBridge: C++へのフル3Dトランスフォーム仲介システムが正常に起動しました。");
        }

        public override void _ExitTree()
        {
            // メモリリーク防止のためイベント解除
            LobbyRealtime.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
        }

        public override void _Process(double delta)
        {
            // WebSocketのイベント回収（C#側の通信を走らせる）
            LobbyRealtime.PollRealtimeEvents();

            // 3Dロビー用にNode3Dとして自分の座標を取得・送信する処理
            if (_cppLobbyManager is Node3D lobbyNode3D)
            {
                var myPlayer = lobbyNode3D.GetNode<Node3D>("MyPlayer");
                if (myPlayer != null && IsInstanceValid(myPlayer))
                {
                    // 自分の最新のフル3D位置・回転データを全員へBroadcast送信
                    LobbyRealtime.LobbySendTransformBroadcastAll(
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

        private void OnPlayerTransformReceivedAll(string playerId, float px, float py, float pz, float rx, float ry, float rz)
        {
            // C#で受け取ったデータをそのままC++のLobbyManager側のオブジェクトへ中継する処理
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