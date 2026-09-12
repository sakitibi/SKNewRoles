using Godot;
using SKNewRoles2.Game.Inventory;

namespace SKNewRoles2.Game
{
    public class PlayerManager
    {
        private readonly PlayerSpawner _playerSpawner = new();
        
        public Node3D MyPlayerInstance { get; private set; }
        public Node HealthComponent { get; private set; }

        public void SpawnPlayer(MainGameScene scene, MainGameSceneNetwork networkHandler, Node3D chunkManager)
        {
            (MyPlayerInstance, HealthComponent) = _playerSpawner.SpawnMyPlayer(scene, networkHandler);
            _playerSpawner.SetPlayerPhysicsEnabled(MyPlayerInstance, false);

            if (MyPlayerInstance != null)
            {
                MyPlayerInstance.Visible = false;

                if (chunkManager != null && GodotObject.IsInstanceValid(chunkManager))
                {
                    chunkManager.Call("set_player_path", MyPlayerInstance.GetPath());
                    GD.Print($"✅ [PlayerManager] ChunkManager に PlayerPath ({MyPlayerInstance.GetPath()}) を設定しました。");
                }
            }
        }

        public void SetVisible(bool visible)
        {
            if (MyPlayerInstance != null && GodotObject.IsInstanceValid(MyPlayerInstance))
            {
                MyPlayerInstance.Visible = visible;
            }
        }

        public void EnablePhysics()
        {
            _playerSpawner.SetPlayerPhysicsEnabled(MyPlayerInstance, true);
        }

        public void GrantInitialItems(HotbarManager hotbarManager)
        {
            if (hotbarManager != null)
            {
                hotbarManager.PickupItem("iron_axe", 1);
                hotbarManager.PickupItem("iron_pickaxe", 1);
                GD.Print("🎒 [PlayerManager] 初期アイテム (iron_axe, iron_pickaxe) を配布しました。");
            }
            else
            {
                GD.PrintErr("⚠️ [PlayerManager] HotbarManager が見つからないため、初期アイテムを配布できませんでした。");
            }
        }
    }
}