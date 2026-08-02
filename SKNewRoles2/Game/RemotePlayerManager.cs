using Godot;
using SKNewRoles2.Game.Network;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class RemotePlayerManager : Node
    {
        private PackedScene _opponentScene;
        private readonly Dictionary<string, Node3D> _otherPlayers = [];
        private readonly Dictionary<string, int> _otherPlayerHps = []; // 各相手のHP保持用
        private string _myUserId;
        private int _myHp = 20;

        public void Initialize(PackedScene opponentScene, string myUserId)
        {
            _opponentScene = opponentScene;
            _myUserId = myUserId;

            RealtimeMessageDispatcher.OnPlayerTransformReceivedAll += OnPlayerTransformReceivedAll;
            RealtimeMessageDispatcher.OnPlayerHpReceived += OnOtherPlayerHpReceived;
        }

        public void SetMyHp(int hp)
        {
            _myHp = hp;
            UpdateAllPlayersVisibility();
        }

        private void OnPlayerTransformReceivedAll(string senderId, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (senderId == _myUserId) return;

            if (!_otherPlayers.TryGetValue(senderId, out Node3D targetPlayer))
            {
                if (_opponentScene == null) return;

                targetPlayer = _opponentScene.Instantiate<Node3D>();
                targetPlayer.Name = $"RemotePlayer_{senderId}";
                AddChild(targetPlayer);
                
                _otherPlayers[senderId] = targetPlayer;
                _otherPlayerHps[senderId] = 20;

                // 新規生成時に表示状態を反映
                UpdateSinglePlayerVisibility(senderId, targetPlayer);
            }

            // 座標の反映処理
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

            _otherPlayerHps[senderId] = currentHp;

            if (_otherPlayers.TryGetValue(senderId, out Node3D remotePlayer))
            {
                if (IsInstanceValid(remotePlayer))
                {
                    if (remotePlayer.HasMethod("set_current_hp"))
                    {
                        remotePlayer.Call("set_current_hp", currentHp);
                    }

                    // HP変更に伴い表示状態を更新
                    UpdateSinglePlayerVisibility(senderId, remotePlayer);
                }
            }
        }

        /// <summary>
        /// 全てのリモートプレイヤーの表示状態を再評価
        /// </summary>
        private void UpdateAllPlayersVisibility()
        {
            foreach (var kvp in _otherPlayers)
            {
                if (IsInstanceValid(kvp.Value))
                {
                    UpdateSinglePlayerVisibility(kvp.Key, kvp.Value);
                }
            }
        }

        /// <summary>
        /// 指定されたリモートプレイヤーの表示条件を判定して適用
        /// </summary>
        private void UpdateSinglePlayerVisibility(string senderId, Node3D remotePlayer)
        {
            int opponentHp = _otherPlayerHps.TryGetValue(senderId, out int hp) ? hp : 20;

            if (opponentHp >= 1)
            {
                SetPlayerVisualState(remotePlayer, visible: true, isTransparent: false);
            }
            else
            {
                // 相手が0以下の場合
                if (_myHp >= 1)
                {
                    SetPlayerVisualState(remotePlayer, visible: false, isTransparent: false);
                }
                else
                {
                    SetPlayerVisualState(remotePlayer, visible: true, isTransparent: true);
                }
            }
        }

        /// <summary>
        /// ノードの可視性およびメッシュの透明度（アルファ値）を設定
        /// </summary>
        private static void SetPlayerVisualState(Node3D playerNode, bool visible, bool isTransparent)
        {
            playerNode.Visible = visible;
            if (!visible) return;

            // 子ノードの MeshInstance3D に対してアルファ値を適用
            SetNodeAlphaRecursive(playerNode, isTransparent ? 0.2f : 1.0f);
        }

        private static void SetNodeAlphaRecursive(Node node, float alpha)
        {
            if (node is MeshInstance3D meshInstance)
            {
                int surfaceCount = meshInstance.GetSurfaceOverrideMaterialCount();
                if (surfaceCount == 0 && meshInstance.Mesh != null)
                {
                    surfaceCount = meshInstance.Mesh.GetSurfaceCount();
                }

                for (int i = 0; i < surfaceCount; i++)
                {
                    Material mat = meshInstance.GetSurfaceOverrideMaterial(i) ?? meshInstance.Mesh?.SurfaceGetMaterial(i);
                    if (mat is StandardMaterial3D stdMat)
                    {
                        StandardMaterial3D dupMat = (StandardMaterial3D)stdMat.Duplicate();
                        dupMat.Transparency = alpha < 1.0f ? BaseMaterial3D.TransparencyEnum.Alpha : BaseMaterial3D.TransparencyEnum.Disabled;
                        Color color = dupMat.AlbedoColor;
                        color.A = alpha;
                        dupMat.AlbedoColor = color;
                        meshInstance.SetSurfaceOverrideMaterial(i, dupMat);
                    }
                }
            }

            foreach (Node child in node.GetChildren())
            {
                SetNodeAlphaRecursive(child, alpha);
            }
        }

        public override void _ExitTree()
        {
            RealtimeMessageDispatcher.OnPlayerTransformReceivedAll -= OnPlayerTransformReceivedAll;
            RealtimeMessageDispatcher.OnPlayerHpReceived -= OnOtherPlayerHpReceived;
        }
    }
}