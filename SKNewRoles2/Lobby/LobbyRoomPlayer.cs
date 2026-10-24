using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;
using SKNewRoles2.Game.Player;

namespace SKNewRoles2.Lobby
{
    public class LobbyRoomPlayer
    {
        private readonly Node3D _owner;
        private readonly PackedScene _playerPrefab;
        private readonly PackedScene _dummyPlayerPrefab;
        private Node3D _myPlayerInstance;
        private readonly PlayerManager _playerManager = new();
        private readonly Dictionary<string, Node3D> _otherPlayers;
        private readonly Dictionary<string, Dictionary<string, string>> _remotePlayerSkins = [];

        public Node3D MyPlayerInstance => _myPlayerInstance;

        public LobbyRoomPlayer(Node3D owner, PackedScene playerPrefab, PackedScene dummyPlayerPrefab, Dictionary<string, Node3D> otherPlayers)
        {
            _owner = owner;
            _playerPrefab = playerPrefab;
            _dummyPlayerPrefab = dummyPlayerPrefab;
            _otherPlayers = otherPlayers;
        }

        /// <summary>
        /// 自分自身の操作用プレイヤープレハブを安全に生成します。
        /// </summary>
        public async Task SpawnPlayerPrefab(Color grassBlockColor)
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
                _owner.AddChild(_myPlayerInstance);
                GD.Print("🚀 自分のプレイヤープレハブの生成に成功しました！");

                _playerManager.EnablePhysics();

                // 保存済みスキンを適用し、その設定内容を他のプレイヤーへブロードキャスト
                var mySkins = LobbySkinManager.ApplySavedSkinAndGetPresets(_myPlayerInstance);
                RealtimeLobbySender.LobbySendSkinBroadcast(mySkins);

                await _owner.ToSignal(_owner.GetTree(), "process_frame");

                // ステージ内のSNR2GrassBlockを全探索して色を一括同期
                List<Node> grassBlocks = [];
                await FindGrassBlocksRecursive(_owner.GetTree().Root, grassBlocks);

                if (grassBlocks.Count > 0)
                {
                    foreach (Node block in grassBlocks)
                    {
                        block.Call("set_grass_color", grassBlockColor);
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
        public void OnRemotePlayerTransformReceived(string playerId, float px, float py, float pz, float rx, float ry, float rz)
        {
            string myId = SessionManager.Instance.CurrentSession?.User?.Id;

            if (!string.IsNullOrEmpty(myId) && playerId == myId)
            {
                return;
            }

            if (_otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode))
            {
                if (GodotObject.IsInstanceValid(remotePlayerNode))
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
                GD.PrintErr($"❌ 相手プレイヤー(ID: {playerId})を生成しようとしましたが, _dummyPlayerPrefab が null です！");
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

            _owner.AddChild(remotePlayer);
            _otherPlayers[playerId] = remotePlayer;

            // 生成時に既に相手のスキン情報を受信していれば、即座に適用する
            if (_remotePlayerSkins.TryGetValue(playerId, out var skinPresets))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayer, skinPresets);
            }
        }

        /// <summary>
        /// 他プレイヤーのスキン情報を受信した際の処理
        /// </summary>
        public void OnRemotePlayerSkinReceived(string playerId, Dictionary<string, string> skinPresets)
        {
            string myId = SessionManager.Instance?.CurrentSession?.User?.Id;
            if (!string.IsNullOrEmpty(myId) && playerId == myId) return;

            // キャッシュに保存
            _remotePlayerSkins[playerId] = skinPresets;

            // すでにプレイヤーが存在していれば、すぐにスキンを適用
            if (_otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode) && GodotObject.IsInstanceValid(remotePlayerNode))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayerNode, skinPresets);
                GD.Print($"🎨 [LobbyRoomPlayer] リモートプレイヤー ({playerId}) のスキンを更新しました。");
            }
        }

        private static async Task FindGrassBlocksRecursive(Node node, List<Node> result)
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