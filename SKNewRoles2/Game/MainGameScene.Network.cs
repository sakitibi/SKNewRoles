using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game
{
    public partial class MainGameSceneNetwork(MainGameScene scene)
    {
        public void UpdateHpUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            Node targetNode = (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent)) ? scene.HealthComponent : scene.MyPlayerInstance;

            string[] curHpKeys = ["CurrentHp", "current_hp", "hp", "Health", "health", "CurrentHealth"];
            foreach (var key in curHpKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hpVal))
                {
                    scene.CurrentHp = hpVal;
                    break;
                }
            }

            string[] maxHpKeys = ["MaxHp", "max_hp", "max_health", "MaxHealth"];
            foreach (var key in maxHpKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    scene.MaxHp = maxVal;
                    break;
                }
            }

            scene.UIController.UpdateHp(scene.CurrentHp, scene.MaxHp);
        }

        public void UpdateHungerUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            string[] curHungerKeys = ["CurrentHunger", "current_hunger", "hunger", "CurrentFood", "food"];
            foreach (var key in curHungerKeys)
            {
                var val = scene.MyPlayerInstance.Get(key);
                if (TryConvertToInt(val, out int hungerVal))
                {
                    scene.CurrentHunger = hungerVal;
                    break;
                }
            }

            string[] maxHungerKeys = ["MaxHunger", "max_hunger", "max_food", "MaxFood"];
            foreach (var key in maxHungerKeys)
            {
                var val = scene.MyPlayerInstance.Get(key);
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

        public void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            scene.CurrentHp = currentHp;
            scene.MaxHp = maxHp;

            scene.UIController?.UpdateHp(currentHp, maxHp);
            scene.SetRemotePlayerHp(currentHp);

            string myUserId = MainGameScene.GetMyUserId();
            _ = SafeSendHpAsync(myUserId, currentHp, maxHp);
        }

        public void OnMyPlayerHungerChanged(int currentHunger, int maxHunger)
        {
            scene.CurrentHunger = currentHunger;
            scene.MaxHunger = maxHunger;

            // scene.UIController?.UpdateHunger(currentHunger, maxHunger);

            string myUserId = MainGameScene.GetMyUserId();
            _ = SafeSendHungerAsync(myUserId, currentHunger, maxHunger);
        }

        private async Task SafeSendHpAsync(string userId, int currentHp, int maxHp)
        {
            try
            {
                await RealtimeBroadcaster.SendHpAsync(scene.Connection, userId, currentHp, maxHp);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] HP送信時例外 (送信スキップ): {ex.Message}");
            }
        }

        private async Task SafeSendHungerAsync(string userId, int currentHunger, int maxHunger)
        {
            try
            {
                await RealtimeBroadcaster.SendHungerAsync(scene.Connection, userId, currentHunger, maxHunger);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] 満腹度送信時例外 (送信スキップ): {ex.Message}");
            }
        }

        public void SendMyTransform()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance)) return;

            Vector3 pos = scene.MyPlayerInstance.GlobalPosition;
            Vector3 rot = scene.MyPlayerInstance.Rotation;

            try
            {
                _ = RealtimeBroadcaster.SendTransformAsync(scene.Connection, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] Transform送信時例外: {ex.Message}");
            }
        }
    }
}