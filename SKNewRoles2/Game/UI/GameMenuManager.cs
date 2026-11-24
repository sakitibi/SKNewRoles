using Godot;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Player;
using SKNewRoles2.Lobby.UI;

namespace SKNewRoles2.Game.UI
{
    public class GameMenuManager(MainGameScene gameScene, PackedScene menuScene, MainGamePlayerHandler playerHandler, RealtimeConnection connection, string myUserId)
    {
        private Control _activeMenuInstance;

        public bool IsMenuOpen => _activeMenuInstance != null && GodotObject.IsInstanceValid(_activeMenuInstance) && _activeMenuInstance.Visible;

        public void ToggleMenu()
        {
            GD.Print($"🔄 [GameMenuManager] ToggleMenu 呼び出し. 現在のメニュー状態(IsMenuOpen): {IsMenuOpen}");
            if (IsMenuOpen)
            {
                CloseMenu();
            }
            else
            {
                OpenMenu();
            }
        }

        public void OpenMenu()
        {
            GD.Print("📂 [GameMenuManager] OpenMenu 実行開始...");
            if (_activeMenuInstance == null && menuScene != null)
            {
                LobbyMenu.isLobby = false;
                _activeMenuInstance = menuScene.Instantiate<Control>();

                CanvasLayer canvasLayer = gameScene.GetNodeOrNull<CanvasLayer>("MenuCanvasLayer");
                if (canvasLayer == null)
                {
                    canvasLayer = new()
                    {
                        Name = "MenuCanvasLayer"
                    };
                    gameScene.AddChild(canvasLayer);
                }
                canvasLayer.AddChild(_activeMenuInstance);

                if (_activeMenuInstance is LobbyMenu menu)
                {
                    menu.ResumeRequested += CloseMenu;
                    
                    menu.InitMenuForGame(connection, myUserId);
                }
            }
            else if (_activeMenuInstance == null && menuScene == null)
            {
                GD.PrintErr("❌ [GameMenuManager] _menuScene (PackedScene) が null です！インスペクター等を確認してください。");
            }

            if (_activeMenuInstance != null)
            {
                _activeMenuInstance.Visible = true;
                Input.MouseMode = Input.MouseModeEnum.Visible;
                
                if (playerHandler?.MyPlayerInstance != null)
                {
                    playerHandler.MyPlayerInstance.Call("set_movement_enabled", false);
                }
                GD.Print("✅ [GameMenuManager] ゲームメニューを表示しました。");
            }
        }

        public void CloseMenu()
        {
            GD.Print("📁 [GameMenuManager] CloseMenu 実行。メニューを破棄して閉じます。");
            DestroyMenu();

            Input.MouseMode = Input.MouseModeEnum.Captured;
            if (playerHandler?.MyPlayerInstance != null)
            {
                playerHandler.MyPlayerInstance.Call("set_movement_enabled", true);
            }
        }

        public void DestroyMenu()
        {
            if (_activeMenuInstance != null && GodotObject.IsInstanceValid(_activeMenuInstance))
            {
                GD.Print("🗑️ [GameMenuManager] DestroyMenu 実行。メニューをキューフリーします。");
                _activeMenuInstance.QueueFree();
            }
            _activeMenuInstance = null;
        }
    }
}