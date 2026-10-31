using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;
using SKNewRoles2.Game.Player;

namespace SKNewRoles2.Lobby
{
    public class LobbyRoomPlayer(Node3D owner, PackedScene playerPrefab, PackedScene dummyPlayerPrefab, Dictionary<string, Node3D> otherPlayers)
    {
        private Node3D _myPlayerInstance;
        private readonly Dictionary<string, Dictionary<string, string>> _remotePlayerSkins = [];
        public List<Node> grassBlocks = [];
        public Node3D MyPlayerInstance => _myPlayerInstance;

        /// <summary>
        /// 自分自身の操作用プレイヤープレハブを安全に生成します。
        /// </summary>
        public async Task SpawnPlayerPrefab(Color grassBlockColor)
        {
            try
            {
                if (playerPrefab == null)
                {
                    GD.PrintErr("❌ _playerPrefab が null のため、自分自身を生成できません。");
                    return;
                }

                _myPlayerInstance = playerPrefab.Instantiate<Node3D>();
                _myPlayerInstance.Position = new Vector3(0.0f, 2.0f, 0.0f);
                _myPlayerInstance.Name = "MyPlayer"; 
                owner.AddChild(_myPlayerInstance);
                GD.Print("🚀 自分のプレイヤープレハブの生成に成功しました！");

                EnablePhysicsOnLobby();

                // 保存済みスキンを適用し、その設定内容を他のプレイヤーへブロードキャスト
                Dictionary<string, string> mySkins = LobbySkinManager.ApplySavedSkinAndGetPresets(_myPlayerInstance);
                await RealtimeLobbySender.LobbySendSkinBroadcast(mySkins);
                await RealtimeLobbySender.LobbySendTransformBroadcastAll(
                    _myPlayerInstance.Position.X,
                    _myPlayerInstance.Position.Y,
                    _myPlayerInstance.Position.Z,
                    _myPlayerInstance.Rotation.X,
                    _myPlayerInstance.Rotation.Y,
                    _myPlayerInstance.Rotation.Z
                );

                await owner.ToSignal(owner.GetTree(), "process_frame");

                // ステージ内のSNR2GrassBlockを全探索して色を一括同期
                await FindGrassBlocksRecursive(owner.GetTree().Root, grassBlocks);
                int grassBlocksCount = grassBlocks.Count;

                if (grassBlocksCount > 0)
                {
                    for (int i = grassBlocksCount - 1;i >= 0; i--)
                    {
                        grassBlocks[i].Call("set_grass_color", grassBlockColor);
                    }
                    GD.Print($"{grassBlocksCount} 個のSNR2GrassBlockを発見し、色を変更しました！");
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ プレイヤー生成中にエラーが発生しました: {ex.Message}");
            }
        }

        public void EnablePhysicsOnLobby()
        {
            PlayerSpawner.SetPlayerPhysicsEnabled(_myPlayerInstance, true);
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

            if (otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode))
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
            if (dummyPlayerPrefab == null)
            {
                GD.PrintErr($"❌ [LobbyRoomPlayer] 相手プレイヤー(ID: {playerId})を生成しようとしましたが, _dummyPlayerPrefab が null です！");
                return;
            }

            if (otherPlayers.ContainsKey(playerId)) return;

            GD.Print($"✨ [LobbyRoomPlayer] 新しいリモートプレイヤーを検知・生成します！ ID: {playerId}");
            
            Node3D remotePlayer = dummyPlayerPrefab.Instantiate<Node3D>();
            remotePlayer.Position = new Vector3(px, py, pz);
            remotePlayer.Rotation = new Vector3(rx, ry, rz);
            remotePlayer.Name = $"RemotePlayer_{playerId}";

            if (remotePlayer.HasMethod("set_target_transform"))
            {
                remotePlayer.Call("set_target_transform", px, py, pz, rx, ry, rz);
            }

            owner.AddChild(remotePlayer);
            otherPlayers[playerId] = remotePlayer;

            // 生成時に既に相手のスキン情報を受信していれば、初期化完了後に遅延適用する
            if (_remotePlayerSkins.TryGetValue(playerId, out var skinPresets))
            {
                GD.Print($"🎨 [LobbyRoomPlayer] プレハブ生成完了。キャッシュされたスキンを遅延適用します: ID={playerId}, Count={skinPresets?.Count ?? 0}");
                
                Callable.From(() => {
                    if (GodotObject.IsInstanceValid(remotePlayer))
                    {
                        LobbySkinManager.ApplySkinPresets(remotePlayer, skinPresets);
                        GD.Print($"🎨 [LobbyRoomPlayer] Deferred application of skin completed for: {playerId}");
                    }
                }).CallDeferred();
            }
            else
            {
                GD.Print($"⚠️ [LobbyRoomPlayer] 生成時、ID={playerId} のスキンキャッシュはまだありません。");
            }

            _ = SendMySkinResyncAsync();
        }

        /// <summary>
        /// 新しいプレイヤーの参加を検知した際、自分のスキンを再送するヘルパー
        /// </summary>
        private async Task SendMySkinResyncAsync()
        {
            await Task.Delay(1000); // プレハブの生成と同期が落ち着くのを1秒待つ
            if (_myPlayerInstance != null && GodotObject.IsInstanceValid(_myPlayerInstance))
            {
                var mySkins = LobbySkinManager.ApplySavedSkinAndGetPresets(_myPlayerInstance);
                await RealtimeLobbySender.LobbySendSkinBroadcast(mySkins);
                GD.Print("[LobbyRoomPlayer] Resent my skin broadcast to sync with newly detected player.");
            }
        }

        /// <summary>
        /// 他プレイヤーのスキン情報を受信した際の処理
        /// </summary>
        public void OnRemotePlayerSkinReceived(string playerId, Dictionary<string, string> skinPresets)
        {
            string myId = SessionManager.Instance?.CurrentSession?.User?.Id;
            GD.Print($"[LobbyRoomPlayer] OnRemotePlayerSkinReceived triggered. TargetID: {playerId}, MyID: {myId}, SkinsCount: {skinPresets?.Count ?? 0}");

            if (!string.IsNullOrEmpty(myId) && playerId == myId)
            {
                GD.Print("[LobbyRoomPlayer] Ignored skin broadcast from myself.");
                return;
            }

            // キャッシュに保存
            _remotePlayerSkins[playerId] = skinPresets;

            // すでにプレイヤーが存在していれば、すぐにスキンを適用
            if (otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode) && GodotObject.IsInstanceValid(remotePlayerNode))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayerNode, skinPresets);
                GD.Print($"[LobbyRoomPlayer] Successfully applied skin to existing remote player: {playerId}");
            }
            else
            {
                GD.Print($"[LobbyRoomPlayer] Remote player node for ID {playerId} not found in scene yet. Cached the skin data.");
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