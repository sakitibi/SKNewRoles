using Godot;

namespace SKNewRoles2.Lobby.UI
{
    public class LobbyMenuManager(LobbyRoom lobbyRoom, PackedScene menuScene, LobbyMyPlayerManager lobbyMyPlayerManager)
    {
        private Control _activeMenuInstance;
        public bool IsMenuOpen => _activeMenuInstance != null && GodotObject.IsInstanceValid(_activeMenuInstance);

        public void ToggleMenu(RoomUI roomUI)
        {
            GD.Print($"🔄 [LobbyMenuManager] ToggleMenu 呼び出し. 現在のメニュー状態(IsMenuOpen): {IsMenuOpen}");
            if (IsMenuOpen)
            {
                CloseMenu(roomUI);
            }
            else
            {
                OpenMenu(roomUI);
            }
        }

        public void OpenMenu(RoomUI roomUI)
        {
            GD.Print("📂 [LobbyMenuManager] OpenMenu 実行開始...");
            if (_activeMenuInstance == null && menuScene != null)
            {
                GD.Print("📂 [LobbyMenuManager] メニューを新規インスタンス化します。");
                _activeMenuInstance = menuScene.Instantiate<Control>();
                
                lobbyRoom.GetNode<CanvasLayer>("CanvasLayer").AddChild(_activeMenuInstance);

                if (_activeMenuInstance is LobbyMenu menu)
                {
                    menu.ResumeRequested += () => CloseMenu(roomUI);
                    menu.InitMenu(roomUI, lobbyRoom);
                    roomUI.SetMenu(menu);
                }
            }
            else if (_activeMenuInstance == null && menuScene == null)
            {
                GD.PrintErr("❌ [LobbyMenuManager] 致命的エラー: _lobbyMenuScene (menuScene) が null です！インスペクターを確認してください。");
            }

            if (_activeMenuInstance != null)
            {
                _activeMenuInstance.Visible = true;
                Input.MouseMode = Input.MouseModeEnum.Visible;
                if (lobbyMyPlayerManager.MyPlayerInstance != null)
                {
                    lobbyMyPlayerManager.MyPlayerInstance?.Call("set_movement_enabled", false);
                }
                GD.Print("✅ [LobbyMenuManager] メニューを表示状態にしました。");
            }
        }

        public void CloseMenu(RoomUI roomUI)
        {
            GD.Print("📁 [LobbyMenuManager] CloseMenu 実行。メニューを完全に破棄して閉じます。");
            DestroyMenu(roomUI);
            Input.MouseMode = Input.MouseModeEnum.Captured;
            if (lobbyMyPlayerManager.MyPlayerInstance != null)
            {
                lobbyMyPlayerManager.MyPlayerInstance?.Call("set_movement_enabled", true);
            }
        }

        public void DestroyMenu(RoomUI roomUI)
        {
            if (_activeMenuInstance != null && GodotObject.IsInstanceValid(_activeMenuInstance))
            {
                GD.Print("🗑️ [LobbyMenuManager] DestroyMenu 実行。メニューをキューフリーします。");
                _activeMenuInstance.QueueFree();
            }
            _activeMenuInstance = null;
            
            roomUI?.SetMenu(null);
        }
    }
}