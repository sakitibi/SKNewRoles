using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game
{
    public partial class GameRoleManager : Node
    {
        private Node _roleManagerCpp;
        private RealtimeConnection _connection;

        public uint MyRole { get; private set; } = 0;
        public uint MyFaction { get; private set; } = 0;
        public bool HasRoleReceived { get; private set; } = false;

        public event Action<uint, uint> OnRoleApplied;

        public void Initialize(Node roleManagerCppNode, RealtimeConnection connection)
        {
            _roleManagerCpp = roleManagerCppNode;
            _connection = connection;

            if (_connection != null)
            {
                _connection.OnRoleAssignedReceived += OnRoleAssignedReceived;
            }
        }

        public async Task AssignRolesToAllPlayers(string myUserId)
        {
            if (_roleManagerCpp == null || !_roleManagerCpp.HasMethod("assign_roles"))
            {
                GD.PrintErr("❌ [AssignRoles] RoleManager C++ ノードが正しく設定されていません。");
                return;
            }

            var playerIdsArray = new Godot.Collections.Array();
            var roomPlayers = SessionManager.Instance?.CurrentRoomPlayerIds;

            if (roomPlayers != null && roomPlayers.Count > 0)
            {
                foreach (var id in roomPlayers)
                {
                    playerIdsArray.Add(id);
                }
            }
            else
            {
                playerIdsArray.Add(myUserId);
            }

            Dictionary roleCountsDict = [];
            roleCountsDict[RoleInfo.RoleIdDictionary.GetValueOrDefault("witch")] = 1; // 人狼 (1人)

            GD.Print($"🎲 [AssignRoles] {playerIdsArray.Count} 人のプレイヤーに役職を割り当てます");

            var rawResult = _roleManagerCpp.Call("assign_roles", playerIdsArray, roleCountsDict);
            var assignmentResult = rawResult.AsGodotDictionary();

            var keysList = new Array<Variant>(assignmentResult.Keys);
            int count = keysList.Count;

            for (int i = 0; i < count; i++)
            {
                Variant key = keysList[i];
                string targetUserId = key.AsString();
                var roleData = assignmentResult[key].AsGodotDictionary();

                uint assignedRole = roleData["role"].AsUInt32();
                uint assignedFaction = roleData["faction"].AsUInt32();

                GD.Print($"🎭 割り当て完了: Player={targetUserId}, Role={assignedRole}, Faction={assignedFaction}");

                if (targetUserId == myUserId)
                {
                    ApplyRole(assignedRole, assignedFaction);
                }
                else
                {
                    if (_connection != null)
                    {
                        await RealtimeBroadcaster.SendRoleAsync(_connection, targetUserId, assignedRole, assignedFaction);
                    }
                }
            }
        }

        public async Task<bool> WaitForRoleAssignedAsync(int timeoutMs = 10000, int checkIntervalMs = 200)
        {
            int maxLoop = timeoutMs / checkIntervalMs;
            int loopCheck = 0;

            while (!HasRoleReceived && loopCheck < maxLoop)
            {
                await Task.Delay(checkIntervalMs);
                loopCheck++;
            }

            return HasRoleReceived;
        }

        private void OnRoleAssignedReceived(string targetUserId, uint roleId, uint factionId)
        {
            string myUserId = GetMyUserId();
            if (targetUserId != myUserId && !string.IsNullOrEmpty(targetUserId)) return;

            if (HasRoleReceived) return;

            ApplyRole(roleId, factionId);
            GD.Print($"📩 [OnRoleAssignedReceived] 役職データを受信しました: Role={MyRole}, Faction={MyFaction}");
        }

        public void ApplyRole(uint roleId, uint factionId)
        {
            MyRole = roleId;
            MyFaction = factionId;
            HasRoleReceived = true;
            GD.Print($"✨ 自分の役職が適用されました: Role={MyRole}, Faction={MyFaction}");

            OnRoleApplied?.Invoke(MyRole, MyFaction);
        }

        private static string GetMyUserId()
        {
            string myUserId = SessionManager.Instance?.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance?.CurrentRoomCode ?? "SingleTest"}";
            }
            return myUserId;
        }

        public override void _ExitTree()
        {
            if (_connection != null)
            {
                _connection.OnRoleAssignedReceived -= OnRoleAssignedReceived;
            }
        }
    }
}