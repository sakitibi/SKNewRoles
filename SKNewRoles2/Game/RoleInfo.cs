using System.Collections.Generic;
using System.Linq;

namespace SKNewRoles2.Game
{
    public static class RoleInfo
    {
        public class RoleData
        {
            public uint Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
        }

        public class FactionData
        {
            public uint Id { get; set; }
            public string Name { get; set; }
        }

        private static Dictionary<string, RoleData> RoleNames { get; set; } = new()
        {
            {
                "students", new() { Id = 0, Name = "生徒", Description = "議論によって魔女を追放せよ。" }
            },
            {
                "witch", new() { Id = 1, Name = "魔女", Description = "生徒に扮し、怪しまれずに全員を排除せよ。" }
            }
        };

        private static Dictionary<string, FactionData> FactionNames { get; set; } = new()
        {
            {
                "students", new() { Id = 0, Name = "生徒陣営" }
            },
            {
                "witch", new() { Id = 1, Name = "魔女陣営" }
            },
            {
                "other", new() { Id = 2, Name = "第三陣営" }
            }
        };

        public static void RegisterRole(string roleKey, uint roleId, string roleName, string description)
        {
            RoleNames[roleKey] = new() { Id = roleId, Name = roleName, Description = description };
            Godot.GD.Print($"[RoleInfo] 🔧 新規役職が登録されました: {roleKey} (ID: {roleId}, Name: {roleName})");
        }

        public static void RegisterFaction(string factionKey, uint factionId, string factionName)
        {
            FactionNames[factionKey] = new() { Id = factionId, Name = factionName };
            Godot.GD.Print($"[RoleInfo] 🔧 新規陣営が登録されました: {factionKey} (ID: {factionId}, Name: {factionName})");
        }

        public static string GetFactionName(uint factionId)
        {
            FactionData faction = FactionNames.Values.FirstOrDefault(f => f.Id == factionId);
            return faction != null ? faction.Name : "不明な陣営";
        }

        public static uint GetFactionId(string factionName)
        {
            FactionData faction = FactionNames.Values.FirstOrDefault(f => f.Name == factionName);
            return faction.Id;
        }

        public static string GetRoleName(uint roleId)
        {
            RoleData role = RoleNames.Values.FirstOrDefault(r => r.Id == roleId);
            return role != null ? role.Name : $"役職ID: {roleId}";
        }

        public static uint GetRoleId(string roleName)
        {
            RoleData role = RoleNames.Values.FirstOrDefault(r => r.Name == roleName);
            return role.Id;
        }

        public static string GetRoleDescription(uint roleId)
        {
            RoleData role = RoleNames.Values.FirstOrDefault(r => r.Id == roleId);
            return role != null ? role.Description : "割り当てられた目的を達成してください。";
        }
    }
}