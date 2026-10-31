using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Lobby;

namespace SKNewRoles2.Game
{
    public class MainGameNetworkHandler(MainGameScene scene)
    {
        private static Vector3 _lastSentPosition = Vector3.Zero;
        private static Vector3 _lastSentRotation = Vector3.Zero;

        public void RegisterEvents(RealtimeConnection connection)
        {
            if (connection == null) return;
            connection.OnAttackReceived += OnRemoteAttackReceived;
            connection.OnSkinReceived += OnRemoteSkinReceived;
        }

        public void UnregisterEvents(RealtimeConnection connection)
        {
            if (connection == null) return;
            connection.OnAttackReceived -= OnRemoteAttackReceived;
            connection.OnSkinReceived -= OnRemoteSkinReceived;
        }

        public void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            scene.CurrentHp = currentHp;
            scene.MaxHp = maxHp;

            scene.UIController?.UpdateHp(currentHp, maxHp);
            scene.SetRemotePlayerHp(currentHp);

            string myUserId = MainGameScene.GetMyUserId();
            _ = SafeSendHpAsync(myUserId, (uint)Math.Max(0, currentHp), (uint)Math.Max(0, maxHp));
        }

        public void OnMyPlayerHungerChanged(int currentHunger, int maxHunger)
        {
            scene.CurrentHunger = currentHunger;
            scene.MaxHunger = maxHunger;

            scene.UIController?.UpdateHunger(currentHunger, maxHunger);

            string myUserId = MainGameScene.GetMyUserId();
            _ = SafeSendHungerAsync(myUserId, (uint)Math.Max(0, currentHunger), (uint)Math.Max(0, maxHunger));
        }

        public void OnPlayerAttackedRemote(string targetPlayerId, uint damage)
        {
            string myUserId = MainGameScene.GetMyUserId();
            if (!string.IsNullOrEmpty(targetPlayerId))
            {
                GD.Print($"[MainGameNetworkHandler] Sending damage {damage} from Attacker={myUserId} to Target={targetPlayerId}.");
                _ = SafeSendAttackAsync(myUserId, targetPlayerId, damage);
            }
        }

        public void OnRemoteAttackReceived(string attackerId, string targetId, uint damage)
        {
            string myUserId = MainGameScene.GetMyUserId();
            GD.Print($"[MainGameNetworkHandler] Received attack event: Attacker={attackerId}, Target={targetId}, MyID={myUserId}");

            if (targetId == myUserId)
            {
                if (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent))
                {
                    GD.Print($"[MainGameNetworkHandler] Player successfully took {damage} damage from {attackerId}!");
                    scene.HealthComponent.Call("take_damage", damage);
                }
                else
                {
                    GD.PrintErr("[MainGameNetworkHandler] Error: HealthComponent is invalid, cannot apply damage.");
                }
            }
            else
            {
                GD.Print("[MainGameNetworkHandler] Ignored attack event as it is not for me.");
            }
        }

        /// <summary>
        /// 他のプレイヤーからスキンデータを受信したときの処理
        /// </summary>
        private void OnRemoteSkinReceived(string playerId, Dictionary<string, string> skinsDict)
        {
            string myUserId = MainGameScene.GetMyUserId();
            if (playerId == myUserId) return; // 自分自身のデータは無視

            GD.Print($"[MainGameNetworkHandler] Received skin data for remote player: {playerId}");

            Node3D remotePlayer = scene.GetNodeOrNull<Node3D>($"RemotePlayers/{playerId}");
            if (remotePlayer != null && GodotObject.IsInstanceValid(remotePlayer))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayer, skinsDict);
                GD.Print($"[MainGameNetworkHandler] Successfully applied skin to remote player: {playerId}");
            }
            else
            {
                GD.PrintErr($"[MainGameNetworkHandler] Warning: Remote player node not found for ID: {playerId}");
            }
        }

        public void ProcessMovementSync()
        {
            Node3D player = scene.MyPlayerInstance;
            if (player != null && GodotObject.IsInstanceValid(player) && player.Visible)
            {
                Vector3 playerPos = player.GlobalPosition;
                Vector3 playerRot = player.Rotation;

                float posThreshold = 0.001f;
                float rotThreshold = 0.001f;

                bool hasMoved = playerPos.DistanceSquaredTo(_lastSentPosition) > (posThreshold * posThreshold);
                bool hasRotated = playerRot.DistanceSquaredTo(_lastSentRotation) > (rotThreshold * rotThreshold);

                if (hasMoved && hasRotated)
                {
                    _lastSentPosition = playerPos;
                    _lastSentRotation = playerRot;
                    SendMyTransform();
                }
            }
        }

        public void SendMyTransform()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance)) return;

            Vector3 pos = scene.MyPlayerInstance.GlobalPosition;
            Vector3 rot = scene.MyPlayerInstance.Rotation;

            try
            {
                _ = RealtimeBroadcaster.SendTransformAsync(scene.Connection, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending transform: {ex.Message}");
            }
        }

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

        private async Task SafeSendHpAsync(string userId, uint currentHp, uint maxHp)
        {
            try
            {
                await RealtimeBroadcaster.SendHpAsync(scene.Connection, userId, currentHp, maxHp);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending HP: {ex.Message}");
            }
        }

        private async Task SafeSendHungerAsync(string userId, uint currentHunger, uint maxHunger)
        {
            try
            {
                await RealtimeBroadcaster.SendHungerAsync(scene.Connection, userId, currentHunger, maxHunger);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending hunger: {ex.Message}");
            }
        }

        private async Task SafeSendAttackAsync(string attackerId, string targetId, uint damage)
        {
            try
            {
                await RealtimeBroadcaster.SendAttackAsync(scene.Connection, attackerId, targetId, damage);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[Realtime] Exception on sending attack: {ex.Message}");
            }
        }

        public async Task UpdateHpUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            Node targetNode = (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent)) ? scene.HealthComponent : scene.MyPlayerInstance;

            string[] curHpKeys = ["CurrentHp", "current_hp", "hp", "Health", "health", "CurrentHealth"];
            foreach (string key in curHpKeys)
            {
                Variant val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hpVal))
                {
                    scene.CurrentHp = hpVal;
                    break;
                }
            }

            string[] maxHpKeys = ["MaxHp", "max_hp", "max_health", "MaxHealth"];
            foreach (string key in maxHpKeys)
            {
                Variant val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    scene.MaxHp = maxVal;
                    break;
                }
            }

            _ = scene.UIController.UpdateHp(scene.CurrentHp, scene.MaxHp);
        }

        private static bool TryConvertToInt(Variant variant, out int result)
        {
            result = 0;
            if (variant.VariantType == Variant.Type.Nil) return false;

            switch (variant.VariantType)
            {
                case Variant.Type.Int:
                    result = (int)variant;
                    return true;
                case Variant.Type.Float:
                    result = Mathf.RoundToInt((float)variant);
                    return true;
                default:
                    return false;
            }
        }
    }
}