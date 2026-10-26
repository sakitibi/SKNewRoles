using Godot;

namespace SKNewRoles2.Game
{
    public class MainGameCombatHandler(MainGameScene scene, MainGameNetworkHandler networkHandler)
    {
        private Camera3D _camera;
        public void HandleInput(InputEvent @event)
        {
            if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Left)
            {
                _camera = scene.GetViewport().GetCamera3D();
                if (scene.MyPlayerInstance != null && _camera != null && GodotObject.IsInstanceValid(scene.MyPlayerInstance))
                {
                    PerformAttack(_camera);
                }
            }
        }

        private void PerformAttack(Camera3D camera)
        {
            GodotObject playerAttack = ClassDB.Instantiate("PlayerAttack").AsGodotObject();
            if (playerAttack != null)
            {
                using (playerAttack)
                {
                    Variant targetIdVar = playerAttack.Call("process_attack", scene.MyPlayerInstance, camera);
                    string targetPlayerId = targetIdVar.AsString();

                    if (!string.IsNullOrEmpty(targetPlayerId))
                    {
                        uint damage = 1;
                        GD.Print($"⚔️ [MainGameCombatHandler] リモートプレイヤー攻撃検知: Target={targetPlayerId}");
                        networkHandler.OnPlayerAttackedRemote(targetPlayerId, damage);
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