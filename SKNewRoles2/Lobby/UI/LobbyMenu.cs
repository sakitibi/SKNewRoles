using Godot;
using System;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.UI
{
    public partial class LobbyMenu : Control
    {
        public event Action ResumeRequested;

        public Button PrivacyToggleButton;
        public Button LeaveButton;
        public Button StartGameButton;

        private RoomUI _roomUI;

        public override void _Ready()
        {
            PrivacyToggleButton = GetNode<Button>("CanvasLayer/PrivacyToggleButton");
            LeaveButton = GetNode<Button>("CanvasLayer/LeaveButton");
            StartGameButton = GetNode<Button>("CanvasLayer/StartGameButton");
        }

        public void InitMenu(RoomUI roomUI, LobbyRoom lobbyRoom)
        {
            _roomUI = roomUI;

            if (PrivacyToggleButton != null)
            {
                PrivacyToggleButton.Pressed += _roomUI.OnPrivacyToggleButtonPressed;
                PrivacyToggleButton.Disabled = !SessionManager.Instance.IsHost;
            }

            if (StartGameButton != null)
            {
                StartGameButton.Pressed += () => {
                    if (SessionManager.Instance.IsHost && !lobbyRoom._isTransitioning)
                    {
                        RealtimeLobbySender.LobbySendStartGame();
                        _ = lobbyRoom.TriggerCountdownAndTransition(); 
                    }
                };
                StartGameButton.Disabled = !SessionManager.Instance.IsHost;
            }

            if (LeaveButton != null)
            {
                LeaveButton?.Pressed += async () => {
                    RealtimeLobbySender.LobbySendLeave();
                    await LobbyNavigation.LeaveLobbyAsync(GetTree(), LeaveButton, lobbyRoom.CleanupEventsPublic);
                };
            }

            _roomUI.UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);
        }
    }
}