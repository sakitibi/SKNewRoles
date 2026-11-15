using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game.Skill.Witch.Witch
{
    public class WitchMagic(MainGameScene scene, PlayerCombatSyncHandler playerCombatSyncHandler)
    {
        public async Task UseSkill(Node user)
        {
            if (user == null || !GodotObject.IsInstanceValid(user)) return;

            GodotObject cppWitchMagic = ClassDB.Instantiate("WitchMagic").AsGodotObject();
            if (cppWitchMagic != null)
            {
                using (cppWitchMagic)
                {
                    CombatSyncProxy proxy = new(playerCombatSyncHandler);

                    cppWitchMagic.Call("initialize", scene, proxy);
                    cppWitchMagic.Call("use_skill", user);
                }
            }
            else
            {
                GD.PrintErr("❌ [WitchMagic] C++側 WitchMagic クラスのインスタンス化に失敗しました。");
            }
        }
    }
}