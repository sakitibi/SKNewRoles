using System.Collections.Generic;
using SKNewRoles2.Game.Inventory;
using SKNewRoles2.Game.Player;

namespace SKNewRoles2.Game.Skill
{
    public static class GrantSkillItems
    {
        public static void GrantInitialSkillItems(
            HotbarManager hotbarManager,
            string skill_id
        )
        {
            Dictionary<string, ushort> SkillItemDic = new() {
                {$"{skill_id}_skill", 1}
            };
            PlayerManager.GrantInitialItems(hotbarManager, SkillItemDic);
        }
    }
}