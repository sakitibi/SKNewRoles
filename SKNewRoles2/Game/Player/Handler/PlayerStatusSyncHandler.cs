using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game.Player.Handler
{
    public class PlayerStatusSyncHandler(MainGameScene scene)
    {
        public void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            scene.CurrentHp = currentHp;
            scene.MaxHp = maxHp;

            scene.UIController?.UpdateHp(currentHp, maxHp);
            scene.SetRemotePlayerHp(currentHp);

            string myUserId = MainGameScene.GetMyUserId();
            _ = SafeSendHpAsync(myUserId, (uint)Math.Max(0, currentHp), (uint)Math.Max(0, maxHp));
        }

        public void OnMyPlayerHungerChanged(int currentHunger, int maxHunger)
        {
            scene.CurrentHunger = currentHunger;
            scene.MaxHunger = maxHunger;

            scene.UIController?.UpdateHunger(currentHunger, maxHunger);

            string myUserId = MainGameScene.GetMyUserId();
            _ = SafeSendHungerAsync(myUserId, (uint)Math.Max(0, currentHunger), (uint)Math.Max(0, maxHunger));
        }

        private async Task SafeSendHpAsync(string userId, uint currentHp, uint maxHp)
        {
            try
            {
                await RealtimeBroadcaster.SendHpAsync(scene.Connection, userId, currentHp, maxHp);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending HP: {ex.Message}");
            }
        }

        private async Task SafeSendHungerAsync(string userId, uint currentHunger, uint maxHunger)
        {
            try
            {
                await RealtimeBroadcaster.SendHungerAsync(scene.Connection, userId, currentHunger, maxHunger);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending hunger: {ex.Message}");
            }
        }
    }
}