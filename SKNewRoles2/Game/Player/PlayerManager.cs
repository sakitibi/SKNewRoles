using Godot;
using SKNewRoles2.Game.Inventory;
using System.Collections.Generic;

namespace SKNewRoles2.Game.Player
{
    public class PlayerManager
    {
        public Node3D MyPlayerInstance { get; private set; }
        public Node HealthComponent { get; private set; }

        public void SetVisible(bool visible)
        {
            if (MyPlayerInstance != null && GodotObject.IsInstanceValid(MyPlayerInstance))
            {
                MyPlayerInstance.Visible = visible;
            }
        }

        public void EnablePhysics()
        {
            PlayerSpawner.SetPlayerPhysicsEnabled(MyPlayerInstance, true);
        }

        public static void GrantInitialItems(
            HotbarManager hotbarManager,
            Dictionary<string, ushort> grantItemDic
        )
        {
            if (hotbarManager != null)
            {
                foreach (KeyValuePair<string, ushort> grantItem in grantItemDic)
                {
                    hotbarManager.PickupItem(grantItem.Key, grantItem.Value);
                }
                string keysCommaSeparated = string.Join(", ", grantItemDic.Keys);
                GD.Print($"🎒 [PlayerManager] 初期アイテム ({keysCommaSeparated}) を配布しました。");
            }
            else
            {
                GD.PrintErr("⚠️ [PlayerManager] HotbarManager が見つからないため、初期アイテムを配布できませんでした。");
            }
        }
    }
}