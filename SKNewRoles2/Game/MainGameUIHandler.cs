using System.Threading.Tasks;
using Godot;

namespace SKNewRoles2.Game
{
    public class MainGameUIHandler(MainGameScene scene)
    {
        public async Task UpdateCoordsUI()
        {
            if (scene.MyPlayerInstance != null && GodotObject.IsInstanceValid(scene.MyPlayerInstance))
            {
                await scene.UIController?.UpdateCoords(scene.MyPlayerInstance.GlobalPosition);
            }
        }

        public async Task UpdateHpUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            Node targetNode = (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent)) ? scene.HealthComponent : scene.MyPlayerInstance;

            string[] curHpKeys = ["CurrentHp", "current_hp", "hp", "Health", "health", "CurrentHealth"];
            foreach (var key in curHpKeys)
            {
                Variant val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hpVal))
                {
                    scene.CurrentHp = hpVal;
                    break;
                }
            }

            string[] maxHpKeys = ["MaxHp", "max_hp", "max_health", "MaxHealth"];
            foreach (var key in maxHpKeys)
            {
                Variant val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    scene.MaxHp = maxVal;
                    break;
                }
            }

            _ = scene.UIController.UpdateHp(scene.CurrentHp, scene.MaxHp);
        }

        public void UpdateHungerUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            Node targetNode = scene.MyPlayerInstance.GetNodeOrNull("HungerComponent");
            if (targetNode == null || !GodotObject.IsInstanceValid(targetNode))
            {
                targetNode = scene.MyPlayerInstance;
            }

            string[] curHungerKeys = ["CurrentHunger", "current_hunger", "hunger", "CurrentFood", "food"];
            foreach (var key in curHungerKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hungerVal))
                {
                    scene.CurrentHunger = hungerVal;
                    break;
                }
            }

            string[] maxHungerKeys = ["MaxHunger", "max_hunger", "max_food", "MaxFood"];
            foreach (var key in maxHungerKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    scene.MaxHunger = maxVal;
                    break;
                }
            }

            scene.UIController.UpdateHunger(scene.CurrentHunger, scene.MaxHunger);
        }

        private static bool TryConvertToInt(Variant variant, out int result)
        {
            result = 0;
            if (variant.VariantType == Variant.Type.Nil) return false;

            switch (variant.VariantType)
            {
                case Variant.Type.Int:
                    result = (int)variant;
                    return true;
                case Variant.Type.Float:
                    result = Mathf.RoundToInt((float)variant);
                    return true;
                default:
                    return false;
            }
        }
    }
}