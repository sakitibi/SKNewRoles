namespace SKNewRoles2.Game
{
    public static class RoleInfo
    {
        public static string GetFactionName(int factionId)
        {
            return factionId switch
            {
                0 => "村人陣営",
                1 => "人狼陣営",
                2 => "第三陣営",
                _ => "不明な陣営"
            };
        }

        public static string GetRoleName(int roleId)
        {
            return roleId switch
            {
                0 => "村人",
                1 => "人狼",
                _ => $"役職ID: {roleId}"
            };
        }

        public static string GetRoleDescription(int roleId)
        {
            return roleId switch
            {
                0 => "議論によって人狼を追放せよ。",
                1 => "村人に扮し、怪しまれずに全員を排除せよ。",
                _ => "割り当てられた目的を達成してください。"
            };
        }
    }
}