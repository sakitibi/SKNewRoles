using Godot;

namespace SKNewRoles2.Lobby.UI
{
    public class LobbyMenuManager(LobbyRoom lobbyRoom, PackedScene menuScene)
    {
        private Control _activeMenuInstance;
        private bool _isMenuOpen = false;

        public bool IsMenuOpen => _isMenuOpen;

        public void ToggleMenu(RoomUI roomUI)
        {
            _isMenuOpen = !_isMenuOpen;
            if (_isMenuOpen)
            {
                OpenMenu(roomUI);
            }
            else
            {
                CloseMenu();
            }
        }

        private void OpenMenu(RoomUI roomUI)
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
            _isMenuOpen = true;
        }

        public void CloseMenu()
        {
            _isMenuOpen = false;
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