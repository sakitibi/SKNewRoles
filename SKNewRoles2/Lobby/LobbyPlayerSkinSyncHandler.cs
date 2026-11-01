using Godot;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;

namespace SKNewRoles2.Lobby
{
    public class LobbyPlayerSkinSyncHandler(Dictionary<string, Dictionary<string, string>> remotePlayerSkins, Dictionary<string, Node3D> otherPlayers)
    {
        public void OnRemotePlayerSkinReceived(string playerId, Dictionary<string, string> skinPresets)
        {
            string myId = SessionManager.Instance?.CurrentSession?.User?.Id;
            GD.Print($"[LobbyPlayerSkinSyncHandler] OnRemotePlayerSkinReceived triggered. TargetID: {playerId}, MyID: {myId}, SkinsCount: {skinPresets?.Count ?? 0}");

            if (!string.IsNullOrEmpty(myId) && playerId == myId)
            {
                GD.Print("[LobbyPlayerSkinSyncHandler] Ignored skin broadcast from myself.");
                return;
            }

            // キャッシュに保存
            remotePlayerSkins[playerId] = skinPresets;

            // すでにプレイヤーが存在していれば、すぐにスキンを適用
            if (otherPlayers.TryGetValue(playerId, out Node3D remotePlayerNode) && GodotObject.IsInstanceValid(remotePlayerNode))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayerNode, skinPresets);
                GD.Print($"[LobbyPlayerSkinSyncHandler] Successfully applied skin to existing remote player: {playerId}");
            }
            else
            {
                GD.Print($"[LobbyPlayerSkinSyncHandler] Remote player node for ID {playerId} not found in scene yet. Cached the skin data.");
            }
        }

        public static async Task SendMySkinResyncAsync(Node3D myPlayerInstance)
        {
            await Task.Delay(1000); // プレハブの生成と同期が落ち着くのを1秒待つ
            if (myPlayerInstance != null && GodotObject.IsInstanceValid(myPlayerInstance))
            {
                Dictionary<string, string> mySkins = LobbySkinManager.ApplySavedSkinAndGetPresets(myPlayerInstance);
                await RealtimeLobbySender.LobbySendSkinBroadcast(mySkins);
                GD.Print("[LobbyPlayerSkinSyncHandler] Resent my skin broadcast to sync with newly detected player.");
            }
        }
    }
}