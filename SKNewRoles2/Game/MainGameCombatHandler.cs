using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game
{
    public class MainGameCombatHandler(MainGameScene scene, PlayerCombatSyncHandler playerCombatSyncHandler)
    {
        public Camera3D Camera { get; set; }
        public void HandleInput(InputEvent @event)
        {
            if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Left)
            {
                Camera = scene.GetViewport().GetCamera3D();
                if (scene.MyPlayerInstance != null && Camera != null && GodotObject.IsInstanceValid(scene.MyPlayerInstance))
                {
                    _ = PerformAttack(Camera);
                }
            }
        }

        private async Task PerformAttack(Camera3D camera)
        {
            GodotObject playerAttack = ClassDB.Instantiate("PlayerAttack").AsGodotObject();
            if (playerAttack != null)
            {
                using (playerAttack)
                {
                    Variant resultVar = playerAttack.Call("process_attack", scene.MyPlayerInstance, camera);
                    if (resultVar.VariantType == Variant.Type.Dictionary)
                    {
                        Godot.Collections.Dictionary resultDict = resultVar.AsGodotDictionary();
                        string targetPlayerId = resultDict.ContainsKey("target_player_id") ? resultDict["target_player_id"].AsString() : "";
                        uint damage = resultDict.ContainsKey("damage") ? resultDict["damage"].AsUInt32() : 1;

                        if (!string.IsNullOrEmpty(targetPlayerId))
                        {
                            GD.Print($"⚔️ [MainGameCombatHandler] リモートプレイヤー攻撃検知: Target={targetPlayerId}, Damage={damage}");
                            playerCombatSyncHandler.OnPlayerAttackedRemote(targetPlayerId, damage);
                        }
                    }
                }
            }
            else
            {
                GD.PrintErr("❌ [MainGameCombatHandler] PlayerAttack クラスのインスタンス化に失敗しました。ClassDBへの登録を確認してください。");
            }
        }
    }
}