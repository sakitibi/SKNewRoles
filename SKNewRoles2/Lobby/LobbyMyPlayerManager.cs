using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.Game.Player;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;

namespace SKNewRoles2.Lobby
{
    public class LobbyMyPlayerManager(Node3D owner, PackedScene playerPrefab)
    {
        private Node3D _myPlayerInstance;
        public Node3D MyPlayerInstance => _myPlayerInstance;
        public List<Node> GrassBlocks { get; } = [];

        public async Task<Dictionary<string, string>> SpawnAndSetupPlayerAsync(Color grassBlockColor)
        {
            try
            {
                if (playerPrefab == null)
                {
                    GD.PrintErr("❌ playerPrefab が null のため、自分自身を生成できません。");
                    return null;
                }

                _myPlayerInstance = playerPrefab.Instantiate<Node3D>();
                _myPlayerInstance.Position = new Vector3(0.0f, 2.0f, 0.0f);
                _myPlayerInstance.Name = "MyPlayer"; 
                owner.AddChild(_myPlayerInstance);
                GD.Print("🚀 自分のプレイヤープレハブの生成に成功しました！");

                EnablePhysics();

                // 保存済みスキンを適用し、プリセットを返す
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
                await FindGrassBlocksRecursive(owner.GetTree().Root, GrassBlocks);
                int grassBlocksCount = GrassBlocks.Count;

                if (grassBlocksCount > 0)
                {
                    for (int i = grassBlocksCount - 1; i >= 0; i--)
                    {
                        GrassBlocks[i].Call("set_grass_color", grassBlockColor);
                    }
                    GD.Print($"{grassBlocksCount} 個のSNR2GrassBlockを発見し、色を変更しました！");
                }

                return mySkins;
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ プレイヤー生成中にエラーが発生しました: {ex.Message}");
                return null;
            }
        }

        public void EnablePhysics()
        {
            if (_myPlayerInstance != null && GodotObject.IsInstanceValid(_myPlayerInstance))
            {
                PlayerSpawner.SetPlayerPhysicsEnabled(_myPlayerInstance, true);
            }
        }

        private static async Task FindGrassBlocksRecursive(Node node, List<Node> result)
        {
            if (node == null) return;

            if (node.GetClass() == "SNR2GrassBlock")
            {
                result.Add(node);
            }
            
            Godot.Collections.Array<Node> chilldren = node.GetChildren();
            for (int i = 0; i < chilldren.Count; i++)
            {
                await FindGrassBlocksRecursive(chilldren[i], result);
            }
        }
    }
}