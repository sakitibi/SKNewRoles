using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby
{
    public partial class LobbyRoom
    {
        /// <summary>
        /// 自分自身の操作用プレイヤープレハブを安全に生成します。
        /// </summary>
        public async Task SpawnPlayerPrefab()
        {
            try
            {
                if (_playerPrefab == null)
                {
                    GD.PrintErr("❌ _playerPrefab が null のため、自分自身を生成できません。");
                    return;
                }

                _myPlayerInstance = _playerPrefab.Instantiate<Node3D>();
                _myPlayerInstance.Position = new Vector3(0.0f, 2.0f, 0.0f);
                _myPlayerInstance.Name = "MyPlayer"; 
                AddChild(_myPlayerInstance);
                GD.Print("🚀 自分のプレイヤープレハブの生成に成功しました！");

                await ToSignal(GetTree(), "process_frame");

                // ステージ内のSNR2GrassBlockを全探索して色を一括同期
                List<Node> grassBlocks = new List<Node>();
                await FindGrassBlocksRecursive(GetTree().Root, grassBlocks);

                if (grassBlocks.Count > 0)
                {
                    foreach (Node block in grassBlocks)
                    {
                        block.Call("set_grass_color", GrassBlockColor);
                    }
                    GD.Print($"{grassBlocks.Count} 個のSNR2GrassBlockを発見し、色を変更しました！");
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ プレイヤー生成中にエラーが発生しました: {ex.Message}");
            }
        }

        /// <summary>
        /// 他のプレイヤーから位置・回転（Broadcast）を受信した際の処理
        /// </summary>
        private void OnRemotePlayerTransformReceived(string playerId, float px, float py, float pz, float rx, float ry, float rz)
        {
            string myId = SessionManager.Instance.CurrentSession?.User?.Id;

            // 1. 自分のIDと同じデータなら無視
            if (!string.IsNullOrEmpty(myId) && playerId == myId)
            {
                return;
            }

            GD.Print($"📡 他プレイヤーの座標を受信: ID={playerId}, Pos=({px}, {py}, {pz})");

            // 2. すでに存在する場合は移動
            if (_otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode))
            {
                if (IsInstanceValid(remotePlayerNode))
                {
                    if (remotePlayerNode.HasMethod("set_target_transform"))
                    {
                        remotePlayerNode.Call("set_target_transform", px, py, pz, rx, ry, rz);
                    }
                    else
                    {
                        remotePlayerNode.Position = new Vector3(px, py, pz);
                        remotePlayerNode.Rotation = new Vector3(rx, ry, rz);
                    }
                }
            }
            else
            {
                // 3. 存在しない場合は新規生成
                SpawnRemotePlayerAll(playerId, px, py, pz, rx, ry, rz);
            }
        }

        /// <summary>
        /// 他人のキャラクター（ダミー）を動的にインスタンス化する安全なメソッド
        /// </summary>
        private void SpawnRemotePlayerAll(string playerId, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (_dummyPlayerPrefab == null)
            {
                GD.PrintErr($"❌ 相手プレイヤー(ID: {playerId})を生成しようとしましたが、_dummyPlayerPrefab が null です！");
                return;
            }

            if (_otherPlayers.ContainsKey(playerId)) return;

            GD.Print($"✨ 新しいリモートプレイヤーを検知・生成します！ ID: {playerId}");
            
            Node3D remotePlayer = _dummyPlayerPrefab.Instantiate<Node3D>();
            remotePlayer.Position = new Vector3(px, py, pz);
            remotePlayer.Rotation = new Vector3(rx, ry, rz);
            remotePlayer.Name = $"RemotePlayer_{playerId}";

            if (remotePlayer.HasMethod("set_target_transform"))
            {
                remotePlayer.Call("set_target_transform", px, py, pz, rx, ry, rz);
            }

            AddChild(remotePlayer);
            _otherPlayers[playerId] = remotePlayer;
        }

        private async Task FindGrassBlocksRecursive(Node node, List<Node> result)
        {
            if (node == null) return;

            if (node.GetClass() == "SNR2GrassBlock")
            {
                result.Add(node);
            }
            
            Godot.Collections.Array<Node> children = node.GetChildren();
            for (int i = 0; i < children.Count; i++)
            {
                await FindGrassBlocksRecursive(children[i], result);
            }
        }
    }
}