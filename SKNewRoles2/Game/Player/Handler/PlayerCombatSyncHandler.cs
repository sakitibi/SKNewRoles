using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game.Player.Handler
{
    public class PlayerCombatSyncHandler(MainGameScene scene)
    {
        public void OnPlayerAttackedRemote(string targetPlayerId, uint damage)
        {
            string myUserId = MainGameScene.GetMyUserId();
            if (!string.IsNullOrEmpty(targetPlayerId))
            {
                GD.Print($"[PlayerCombatSyncHandler] Sending damage {damage} from Attacker={myUserId} to Target={targetPlayerId}.");
                _ = SafeSendAttackAsync(myUserId, targetPlayerId, damage);
            }
        }

        public void OnRemoteAttackReceived(string attackerId, string targetId, uint damage)
        {
            string myUserId = MainGameScene.GetMyUserId();
            GD.Print($"[PlayerCombatSyncHandler] Received attack event: Attacker={attackerId}, Target={targetId}, MyID={myUserId}");

            if (targetId == myUserId)
            {
                if (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent))
                {
                    GD.Print($"[PlayerCombatSyncHandler] Player successfully took {damage} damage from {attackerId}!");
                    scene.HealthComponent.Call("take_damage", damage);
                }
                else
                {
                    GD.PrintErr("[PlayerCombatSyncHandler] Error: HealthComponent is invalid, cannot apply damage.");
                }
            }
            else
            {
                GD.Print("[PlayerCombatSyncHandler] Ignored attack event as it is not for me.");
            }
        }

        private async Task SafeSendAttackAsync(string attackerId, string targetId, uint damage)
        {
            try
            {
                await RealtimeBroadcaster.SendAttackAsync(scene.Connection, attackerId, targetId, damage);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending attack: {ex.Message}");
            }
        }
    }
}