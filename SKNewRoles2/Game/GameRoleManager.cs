using Godot;
using Godot.Collections;
using System;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game
{
    public partial class GameRoleManager : Node
    {
        private Node _roleManagerCpp;

        public int MyRole { get; private set; } = -1;
        public int MyFaction { get; private set; } = -1;
        public bool HasRoleReceived { get; private set; } = false;

        public event Action<int, int> OnRoleApplied;
        private readonly RealtimeConnection _connection = new();

        public void Initialize(Node roleManagerCppNode)
        {
            _roleManagerCpp = roleManagerCppNode;
            RealtimeMessageDispatcher.OnRoleAssignedReceived += OnRoleAssignedReceived;
        }

        public async Task AssignRolesToAllPlayers(string myUserId)
        {
            if (_roleManagerCpp == null || !_roleManagerCpp.HasMethod("assign_roles"))
            {
                GD.PrintErr("❌ [AssignRoles] RoleManager が正しく設定されていません");
                return;
            }

            var playerIdsArray = new Godot.Collections.Array();

            if (SessionManager.Instance?.CurrentRoomPlayerIds != null && SessionManager.Instance.CurrentRoomPlayerIds.Count > 0)
            {
                var playerIds = SessionManager.Instance.CurrentRoomPlayerIds;
                int playerCount = playerIds.Count;

                for (int i = 0; i < playerCount; i++)
                {
                    playerIdsArray.Add(playerIds[i]);
                }
            }
            else
            {
                playerIdsArray.Add(myUserId);
            }

            Dictionary roleCountsDict = [];
            roleCountsDict[1] = 1; // 役職ID 1 (人狼) を 1人

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

                int assignedRole = roleData["role"].AsInt32();
                int assignedFaction = roleData["faction"].AsInt32();

                GD.Print($"🎭 割り当て完了: Player={targetUserId}, Role={assignedRole}, Faction={assignedFaction}");

                if (targetUserId == myUserId)
                {
                    ApplyRole(assignedRole, assignedFaction);
                }
                else
                {
                    await RealtimeBroadcaster.SendRoleAsync(_connection, targetUserId, assignedRole, assignedFaction);
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

        private void OnRoleAssignedReceived(string targetUserId, int roleId, int factionId)
        {
            string myUserId = GetMyUserId();
            if (targetUserId != myUserId && !string.IsNullOrEmpty(targetUserId)) return;

            if (HasRoleReceived) return;

            ApplyRole(roleId, factionId);
            GD.Print($"📩 [OnRoleAssignedReceived] 役職データを受信しました: Faction={MyFaction}, Role={MyRole}");
        }

        public void ApplyRole(int roleId, int factionId)
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
            RealtimeMessageDispatcher.OnRoleAssignedReceived -= OnRoleAssignedReceived;
        }
    }
}