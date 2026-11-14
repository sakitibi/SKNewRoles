using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game.Skill.Witch.Witch
{
    public class WitchMagic(MainGameScene scene, PlayerCombatSyncHandler playerCombatSyncHandler)
    {
        public async Task UseSkill(Node user)
        {
            ushort damageAmount = 20;
            float delaySeconds = 10.0f;

            if (user == null || !GodotObject.IsInstanceValid(user)) return;

            string targetPlayerId = GetTargetPlayerId(user);
            if (string.IsNullOrEmpty(targetPlayerId))
            {
                GD.Print("[WitchMagic] 5ブロック以内にターゲットが見つからないため、スキルをキャンセルします。");
                return;
            }

            GD.Print($"[WitchMagic] 「魔女の魔法」を使用しました！ ターゲット: {targetPlayerId}。{delaySeconds}秒後に魔法が発動します。");

            // 10秒間待機
            await user.ToSignal(user.GetTree().CreateTimer(delaySeconds), SceneTreeTimer.SignalName.Timeout);

            if (user == null || !GodotObject.IsInstanceValid(user)) return;

            GD.Print($"[WitchMagic] 10秒経過！ 対象 ({targetPlayerId}) に {damageAmount} のダメージを与えます。");

            await ApplyDamageToTarget(targetPlayerId, damageAmount);
        }

        private string GetTargetPlayerId(Node user)
        {
            Camera3D camera = scene.GetViewport()?.GetCamera3D();
            if (camera == null) return string.Empty;

            GodotObject playerAttack = ClassDB.Instantiate("PlayerAttack").AsGodotObject();
            if (playerAttack != null)
            {
                using (playerAttack)
                {
                    Variant resultVar = playerAttack.Call("process_attack", user, camera);
                    if (resultVar.VariantType == Variant.Type.Dictionary)
                    {
                        Godot.Collections.Dictionary resultDict = resultVar.AsGodotDictionary();
                        return resultDict.ContainsKey("target_player_id") ? resultDict["target_player_id"].AsString() : "";
                    }
                }
            }
            return string.Empty;
        }

        private async Task ApplyDamageToTarget(string targetPlayerId, ushort damageAmount)
        {
            if (!string.IsNullOrEmpty(targetPlayerId))
            {
                playerCombatSyncHandler.OnPlayerAttackedRemote(targetPlayerId, damageAmount);
            }
            await Task.CompletedTask;
        }
    }
}