using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game
{
    public partial class MainGameSceneNetwork(MainGameScene scene)
    {
        public void UpdateHpUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            Node targetNode = (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent)) ? scene.HealthComponent : scene.MyPlayerInstance;

            string[] curHpKeys = ["CurrentHp", "current_hp", "hp", "Health", "health", "CurrentHealth"];
            foreach (var key in curHpKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hpVal))
                {
                    scene.CurrentHp = hpVal;
                    break;
                }
            }

            string[] maxHpKeys = ["MaxHp", "max_hp", "max_health", "MaxHealth"];
            foreach (var key in maxHpKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    scene.MaxHp = maxVal;
                    break;
                }
            }

            scene.UIController.UpdateHp(scene.CurrentHp, scene.MaxHp);
        }

        public void UpdateHungerUIFromPlayer()
        {
            if (scene.MyPlayerInstance == null || !GodotObject.IsInstanceValid(scene.MyPlayerInstance) || scene.UIController == null) return;

            Node targetNode = scene.MyPlayerInstance.GetNodeOrNull("HungerComponent");
            if (targetNode == null || !GodotObject.IsInstanceValid(targetNode))
            {
                targetNode = scene.MyPlayerInstance;
            }

            string[] curHungerKeys = ["CurrentHunger", "current_hunger", "hunger", "CurrentFood", "food"];
            foreach (var key in curHungerKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hungerVal))
                {
                    scene.CurrentHunger = hungerVal;
                    break;
                }
            }

            string[] maxHungerKeys = ["MaxHunger", "max_hunger", "max_food", "MaxFood"];
            foreach (var key in maxHungerKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    scene.MaxHunger = maxVal;
                    break;
                }
            }

            scene.UIController.UpdateHunger(scene.CurrentHunger, scene.MaxHunger);
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

        public void OnPlayerAttacked(Node hitNode, int damage)
        {
            if (hitNode == null || !GodotObject.IsInstanceValid(hitNode)) return;

            string targetUserId = hitNode.HasMeta("player_id") ? hitNode.GetMeta("player_id").AsString() : hitNode.GetName();
            string myUserId = MainGameScene.GetMyUserId();

            if (!string.IsNullOrEmpty(targetUserId))
            {
                _ = SafeSendAttackAsync(myUserId, targetUserId, (uint)Math.Max(0, damage));
            }
        }

        public void OnPlayerAttackedRemote(string targetPlayerId, uint damage)
        {
            string myUserId = MainGameScene.GetMyUserId();
            if (!string.IsNullOrEmpty(targetPlayerId))
            {
                GD.Print($"⚔️ [Network送信前] Attacker={myUserId} -> Target={targetPlayerId} へダメージ {damage} を送信します。");
                _ = SafeSendAttackAsync(myUserId, targetPlayerId, damage);
            }
        }

        public void OnRemoteAttackReceived(string attackerId, string targetId, uint damage)
        {
            string myUserId = MainGameScene.GetMyUserId();
            GD.Print($"📥 [Network受信] 攻撃イベントを受信: Attacker={attackerId}, Target={targetId}, 自分のID={myUserId}");

            if (targetId == myUserId)
            {
                if (scene.HealthComponent != null && GodotObject.IsInstanceValid(scene.HealthComponent))
                {
                    GD.Print($"💥 [被弾処理成功] プレイヤーが {attackerId} から {damage} のダメージを受けました！");
                    scene.HealthComponent.Call("take_damage", damage);
                }
                else
                {
                    GD.PrintErr("❌ [被弾エラー] HealthComponent が無効なためダメージを適用できません。");
                }
            }
            else
            {
                GD.Print("ℹ️ [Network受信] 自分宛ての攻撃ではないため無視しました。");
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
                GD.PrintErr($"⚠️ [Realtime] HP送信時例外 (送信スキップ): {ex.Message}");
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
                GD.PrintErr($"⚠️ [Realtime] 満腹度送信時例外 (送信スキップ): {ex.Message}");
            }
        }

        private async Task SafeSendAttackAsync(string attackerId, string targetId, uint damage)
        {
            try
            {
                await RealtimeBroadcaster.SendAttackAsync(scene.Connection, attackerId, targetId, damage);
                GD.Print("✅ [Realtime] 攻撃のブロードキャスト送信処理が完了しました。");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] 攻撃送信時例外: {ex.Message}");
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
                GD.PrintErr($"⚠️ [Realtime] Transform送信時例外: {ex.Message}");
            }
        }
    }
}