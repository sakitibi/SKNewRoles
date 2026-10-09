using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public static class RoleInfo
    {
        public static Dictionary<string, int> RoleIdDictionary { get; set; } = new()
        {
            {"students", 0},
            {"witch", 1}
        };

        public static Dictionary<string, int> FactionIdDictionary { get; set; } = new()
        {
            {"students", 0},
            {"witch", 1},
            {"other", 2}
        };
        
        public static string GetFactionName(int factionId)
        {
            return factionId switch
            {
                0 => "生徒陣営",
                1 => "魔女陣営",
                2 => "第三陣営",
                _ => "不明な陣営"
            };
        }

        public static string GetRoleName(int roleId)
        {
            return roleId switch
            {
                0 => "生徒",
                1 => "魔女",
                _ => $"役職ID: {roleId}"
            };
        }

        public static string GetRoleDescription(int roleId)
        {
            return roleId switch
            {
                0 => "議論によって魔女を追放せよ。",
                1 => "生徒に扮し、怪しまれずに全員を排除せよ。",
                _ => "割り当てられた目的を達成してください。"
            };
        }
    }
}