using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Lobby;

namespace SKNewRoles2.Game.Player.Handler
{
    public class PlayerSkinSyncHandler(MainGameScene scene)
    {
        public async Task SendMySkinAsync(Dictionary<string, string> skinPresets)
        {
            string myUserId = MainGameScene.GetMyUserId();
            try
            {
                await RealtimeBroadcaster.SendSkinAsync(scene.Connection, myUserId, skinPresets);
                GD.Print("[Realtime] Sent my skin info in game stage successfully.");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending skin: {ex.Message}");
            }
        }

        public void OnRemoteSkinReceived(string playerId, Dictionary<string, string> skinsDict)
        {
            string myUserId = MainGameScene.GetMyUserId();
            if (playerId == myUserId) return; // 自分自身のデータは無視

            GD.Print($"[PlayerSkinSyncHandler] Received skin data for remote player: {playerId}");

            Node3D remotePlayer = scene.GetNodeOrNull<Node3D>($"RemotePlayers/{playerId}");
            if (remotePlayer != null && GodotObject.IsInstanceValid(remotePlayer))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayer, skinsDict);
                GD.Print($"[PlayerSkinSyncHandler] Successfully applied skin to remote player: {playerId}");
            }
            else
            {
                GD.PrintErr($"[PlayerSkinSyncHandler] Warning: Remote player node not found for ID: {playerId}");
            }
        }
    }
}