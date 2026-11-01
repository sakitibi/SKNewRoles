using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public static class RoleInfo
    {
        // 役職キーとIDの対応表
        public static Dictionary<string, uint> RoleIdDictionary { get; set; } = new()
        {
            {"students", 0},
            {"witch", 1}
        };

        // 陣営キーとIDの対応表
        public static Dictionary<string, uint> FactionIdDictionary { get; set; } = new()
        {
            {"students", 0},
            {"witch", 1},
            {"other", 2}
        };
        public static Dictionary<uint, string> RoleNames { get; set; } = new()
        {
            { 0, "生徒" },
            { 1, "魔女" }
        };

        public static Dictionary<uint, string> RoleDescriptions { get; set; } = new()
        {
            { 0, "議論によって魔女を追放せよ。" },
            { 1, "生徒に扮し、怪しまれずに全員を排除せよ。" }
        };

        public static Dictionary<uint, string> FactionNames { get; set; } = new()
        {
            { 0, "生徒陣営" },
            { 1, "魔女陣営" },
            { 2, "第三陣営" }
        };

        /// <summary>
        /// MODや外部スクリプトから新しい役職を動的に登録します。
        /// </summary>
        public static void RegisterRole(string roleKey, uint roleId, string roleName, string description)
        {
            RoleIdDictionary[roleKey] = roleId;
            RoleNames[roleId] = roleName;
            RoleDescriptions[roleId] = description;
            Godot.GD.Print($"[RoleInfo] 🔧 新規役職が登録されました: {roleKey} (ID: {roleId}, Name: {roleName})");
        }

        /// <summary>
        /// MODや外部スクリプトから新しい陣営を動的に登録します。
        /// </summary>
        public static void RegisterFaction(string factionKey, uint factionId, string factionName)
        {
            FactionIdDictionary[factionKey] = factionId;
            FactionNames[factionId] = factionName;
            Godot.GD.Print($"[RoleInfo] 🔧 新規陣営が登録されました: {factionKey} (ID: {factionId}, Name: {factionName})");
        }

        public static string GetFactionName(uint factionId)
        {
            if (FactionNames.TryGetValue(factionId, out var name))
            {
                return name;
            }
            return "不明な陣営";
        }

        public static string GetRoleName(uint roleId)
        {
            if (RoleNames.TryGetValue(roleId, out var name))
            {
                return name;
            }
            return $"役職ID: {roleId}";
        }

        public static string GetRoleDescription(uint roleId)
        {
            if (RoleDescriptions.TryGetValue(roleId, out string description))
            {
                return description;
            }
            return "割り当てられた目的を達成してください。";
        }
    }
}