using Godot;
using Godot.Collections;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;
using SKNewRoles2.SessionManagerSystem;
using System.Collections.Generic;
using SKNewRoles2.Lobby.JOIN.Services;

namespace SKNewRoles2.Game
{
    public partial class GameRoleManager : Node
    {
        private Node _roleManagerCpp;
        private RealtimeConnection _connection;

        public uint MyRole { get; private set; } = 0;
        public uint MyFaction { get; private set; } = 0;
        public bool HasRoleReceived { get; private set; } = false;
        public Dictionary RoleCountsDict { get; set; }
        public Dictionary RoleFactionsDict { get; set; }

        public event Action<uint, uint> OnRoleApplied;

        public void Initialize(Node roleManagerCppNode, RealtimeConnection connection)
        {
            _roleManagerCpp = roleManagerCppNode;
            _connection = connection;

            if (_connection != null)
            {
                _connection.OnRoleAssignedReceived += OnRoleAssignedReceived;
                GD.Print("✅ [GameRoleManager] RealtimeConnection の OnRoleAssignedReceived イベントを購読しました。");
            }
            else
            {
                GD.PrintErr("❌ [GameRoleManager] Initialize 時に connection が null です。");
            }
        }

        public async Task AssignRolesToAllPlayers(string myUserId)
        {
            if (_roleManagerCpp == null || !_roleManagerCpp.HasMethod("assign_roles"))
            {
                GD.PrintErr("❌ [AssignRoles] RoleManager C++ ノードが正しく設定されていません。");
                return;
            }

            Godot.Collections.Array playerIdsArray = [];
            List<string> roomPlayers = SessionManager.Instance?.CurrentRoomPlayerIds;
            int roomPlayersCount = roomPlayers.Count;

            if (roomPlayers != null && roomPlayersCount > 0)
            {
                for (int i = 0;i < roomPlayersCount; i++)
                {
                    playerIdsArray.Add(roomPlayers[i]);
                    GD.Print($"📋 [AssignRoles] ルーム参加者IDを追加: {roomPlayers[i]}");
                }
            }
            else
            {
                playerIdsArray.Add(myUserId);
                GD.Print($"📋 [AssignRoles] ルーム参加者が見つからないため自分のIDのみ追加: {myUserId}");
            }

            uint witchRoleId = RoleInfo.RoleIdDictionary["witch"];

            RoleCountsDict.Add(witchRoleId, 1);
            RoleFactionsDict.Add(witchRoleId, 1);

            GD.Print($"🎲 [AssignRoles] {playerIdsArray.Count} 人のプレイヤーに役職を割り当てます (Witch ID: {witchRoleId})");

            Variant rawResult = _roleManagerCpp.Call(
                "assign_roles",
                playerIdsArray,
                RoleCountsDict,
                RoleFactionsDict
            );
            Dictionary assignmentResult = rawResult.AsGodotDictionary();

            if (assignmentResult == null || assignmentResult.Count == 0)
            {
                GD.PrintErr("❌ [AssignRoles] C++ 側からの役職割り当て結果が空です。");
                return;
            }

            var keysList = new Array<Variant>(assignmentResult.Keys);
            int count = keysList.Count;

            for (int i = 0; i < count; i++)
            {
                Variant key = keysList[i];
                string targetUserId = key.AsString();
                Dictionary roleData = assignmentResult[key].AsGodotDictionary();

                uint assignedRole = roleData["role"].AsUInt32();
                uint assignedFaction = roleData["faction"].AsUInt32();

                GD.Print($"🎭 割り当て結果: TargetUser={targetUserId}, Role={assignedRole}, Faction={assignedFaction}");

                if (targetUserId == myUserId)
                {
                    GD.Print("👑 [AssignRoles] 自分自身の役職を直接適用します。");
                    ApplyRole(assignedRole, assignedFaction);
                }
                else
                {
                    if (_connection != null)
                    {
                        _ = SendRoleWithRetryAsync(targetUserId, assignedRole, assignedFaction);
                    }
                    else
                    {
                        GD.PrintErr("❌ [AssignRoles] Connection が null のためゲストへ送信できません。");
                    }
                }
            }
        }

        private async Task SendRoleWithRetryAsync(string targetUserId, uint role, uint faction)
        {
            for (byte retry = 0; retry < 5; retry++)
            {
                GD.Print($"📡 [AssignRoles] ゲスト (Target={targetUserId}) へ役職データを送信中 (試行 {retry + 1}/5)...");
                await RealtimeBroadcaster.SendRoleAsync(_connection, targetUserId, role, faction);
                await Task.Delay(1500);
            }
        }

        public async Task<bool> WaitForRoleAssignedAsync(int timeoutMs = 15000, int checkIntervalMs = 200)
        {
            int maxLoop = timeoutMs / checkIntervalMs;
            uint loopCheck = 0;

            GD.Print($"⏳ [WaitForRoleAssignedAsync] 役職データの受信待ちを開始します (最大 {timeoutMs}ms)...");

            while (!HasRoleReceived && loopCheck < maxLoop)
            {
                _connection?.Poll();

                if (loopCheck % 10 == 0)
                {
                    await LobbyQueryService.JoinLobbyAsync(SessionManager.Instance.CurrentRoomCode);
                    GD.Print($"⏳ [WaitForRoleAssignedAsync] 待機中... ({loopCheck * checkIntervalMs}ms / {timeoutMs}ms)");
                }

                await Task.Delay(checkIntervalMs);
                loopCheck++;
            }

            if (HasRoleReceived)
            {
                GD.Print("✅ [WaitForRoleAssignedAsync] 役職データの受信を確認しました。");
            }
            else
            {
                GD.PrintErr("⚠️ [WaitForRoleAssignedAsync] タイムアウトしました。役職データが届きませんでした。");
            }

            return HasRoleReceived;
        }

        private void OnRoleAssignedReceived(string targetUserId, uint roleId, uint factionId)
        {
            string myUserId = GetMyUserId();
            GD.Print($"📩 [OnRoleAssignedReceived] 受信イベント検知: TargetUser={targetUserId}, 自分のID={myUserId}, Role={roleId}, Faction={factionId}");

            if (targetUserId != myUserId && !string.IsNullOrEmpty(targetUserId))
            {
                GD.Print($"ℹ️ [OnRoleAssignedReceived] 自分宛てではないためスキップします (Target: {targetUserId} != Me: {myUserId})");
                return;
            }

            if (HasRoleReceived)
            {
                GD.Print("ℹ️ [OnRoleAssignedReceived] すでに役職が適用済みのためスキップします。");
                return;
            }

            ApplyRole(roleId, factionId);
            GD.Print($"✨ [OnRoleAssignedReceived] 役職データの受信・適用が成功しました: Role={MyRole}, Faction={MyFaction}");
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