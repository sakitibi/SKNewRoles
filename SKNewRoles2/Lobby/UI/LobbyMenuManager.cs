using Godot;

namespace SKNewRoles2.Lobby.UI
{
    public class LobbyMenuManager(LobbyRoom lobbyRoom, PackedScene menuScene)
    {
        private Control _activeMenuInstance;
        public bool IsMenuOpen => _activeMenuInstance != null && _activeMenuInstance.Visible;

        public void ToggleMenu(RoomUI roomUI)
        {
            if (IsMenuOpen)
            {
                CloseMenu();
            }
            else
            {
                OpenMenu(roomUI);
            }
        }

        public void OpenMenu(RoomUI roomUI)
        {
            if (_activeMenuInstance == null && menuScene != null)
            {
                _activeMenuInstance = (Control)menuScene.Instantiate();
                
                if (_activeMenuInstance is LobbyMenu menu)
                {
                    menu.ResumeRequested += CloseMenu;
                    menu.InitMenu(roomUI, lobbyRoom);
                    roomUI.SetMenu(menu);
                }

                lobbyRoom.GetNode<CanvasLayer>("CanvasLayer").AddChild(_activeMenuInstance);
            }

            if (_activeMenuInstance != null)
            {
                _activeMenuInstance.Visible = true;
                Input.MouseMode = Input.MouseModeEnum.Visible;
            }
        }

        public void CloseMenu()
        {
            if (_activeMenuInstance != null)
            {
                _activeMenuInstance.Visible = false;
                Input.MouseMode = Input.MouseModeEnum.Captured;
            }
        }

        public void DestroyMenu()
        {
            _activeMenuInstance?.QueueFree();
            _activeMenuInstance = null;
        }
    }
}