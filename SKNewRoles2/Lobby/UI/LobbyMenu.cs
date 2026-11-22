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
        internal static bool isLobby = false;

        private RoomUI _roomUI;

        public override void _Ready()
        {
            GD.Print("🖥️ [LobbyMenu] メニューシーンが _Ready になりました。");
            PrivacyToggleButton = GetNodeOrNull<Button>("CanvasLayer/PrivacyToggleButton");
            LeaveButton = GetNodeOrNull<Button>("CanvasLayer/LeaveButton");
            StartGameButton = GetNode<Button>("CanvasLayer/StartGameButton");
            
            Input.MouseMode = Input.MouseModeEnum.Visible;
            if (!isLobby)
            {
                PrivacyToggleButton.Disabled = true;
                StartGameButton.Disabled = true;
            }
        }

        public override void _Process(double delta)
        {
            if (Input.MouseMode != Input.MouseModeEnum.Visible)
            {
                Input.MouseMode = Input.MouseModeEnum.Visible;
            }
        }

        public void InitMenu(RoomUI roomUI, LobbyRoom lobbyRoom)
        {
            _roomUI = roomUI;
            GD.Print("🖥️ [LobbyMenu] InitMenu が呼び出されました。");

            if (PrivacyToggleButton != null)
            {
                PrivacyToggleButton.Pressed += _roomUI.OnPrivacyToggleButtonPressed;
                PrivacyToggleButton.Disabled = !SessionManager.Instance.IsHost;
            }

            if (StartGameButton != null)
            {
                StartGameButton.Pressed += () => {
                    GD.Print("🖱️ [LobbyMenu] スタートボタンが押されました。");
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
                    GD.Print("🖱️ [LobbyMenu] 退出ボタンが押されました。");
                    RealtimeLobbySender.LobbySendLeave();
                    await LobbyNavigation.LeaveLobbyAsync(GetTree(), LeaveButton, lobbyRoom.CleanupEventsPublic);
                };
            }

            _roomUI.UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed("ui_cancel"))
            {
                GD.Print("🔑 [LobbyMenu] メニュー内でESCキー（ui_cancel）を検知しました。ResumeRequested を発火します。");
                ResumeRequested?.Invoke();
                GetViewport().SetInputAsHandled();
            }
        }
    }
}