using Godot;
using SKNewRoles2.Lobby.JOIN.Services;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.UI
{
    public partial class RoomUI(LobbyRoom lobbyRoom)
    {
        private LobbyMenu _lobbyMenu;

        public void SetMenu(LobbyMenu menu)
        {
            _lobbyMenu = menu;
            GD.Print("🔗 [RoomUI] LobbyMenu の参照が RoomUI にセットされました。");
        }

        public void UpdateRoomInfoUI()
        {
            if (lobbyRoom?.RoomInfoLabel == null) return;
            string roomCode = SessionManager.Instance.CurrentRoomCode;
            lobbyRoom.RoomInfoLabel.Text = $"部屋コード: {roomCode}";
        }

        public async void OnStartGameButtonPressed()
        {
            if (_lobbyMenu?.StartGameButton != null)
            {
                _lobbyMenu.StartGameButton.Disabled = true;
            }

            GD.Print("🎬 ホストがゲームを開始しました。Supabaseのロビーを非アクティブ化して全員の画面を一斉遷移させます...");
            bool success = await LobbySettings.CloseLobbyAsync(SessionManager.Instance.CurrentRoomCode);

            if (success)
            {
                GD.Print("✅ ホスト側のロビー非アクティブ化に成功しました。ホスト自身もメインステージへ遷移します。");
                _ = lobbyRoom.TriggerCountdownAndTransition();
            }
            else
            {
                GD.PrintErr("❌ ロビーの非アクティブ化（ゲーム開始処理）に失敗しました。");
                if (_lobbyMenu?.StartGameButton != null)
                {
                    _lobbyMenu.StartGameButton.Disabled = false;
                }
            }
        }

        public async void OnRoomSettingsChangedFromServer()
        {
            string currentCode = SessionManager.Instance.CurrentRoomCode;
            if (string.IsNullOrEmpty(currentCode)) return;

            int lobbyStatus = await LobbyQueryService.CheckLobbyStatusAsync(currentCode);
            
            if (lobbyStatus == 0)
            {
                UpdateRoomInfoUI();
                UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);
            }
            else if (lobbyStatus == 1)
            {
                _ = lobbyRoom.TriggerCountdownAndTransition();
            }
            else
            {
                lobbyRoom.LeaveLobbyForced();
            }
        }

        public void UpdatePrivacyButtonVisual(bool isPublic)
        {
            Button privacyBtn = _lobbyMenu?.PrivacyToggleButton;
            if (privacyBtn == null)
            {
                GD.PrintErr("⚠️ [RoomUI] UpdatePrivacyButtonVisual: privacyBtn が null です。");
                return;
            }

            Color normalColor = isPublic ? RoomColorData.PublicNormalColor : RoomColorData.PrivateNormalColor;
            Color hoverColor = isPublic ? RoomColorData.PublicHoverColor : RoomColorData.PrivateHoverColor;
            Color pressedColor = isPublic ? RoomColorData.PublicPressedColor : RoomColorData.PrivatePressedColor;

            privacyBtn.Text = isPublic ? "公開中" : "非公開";
            privacyBtn.SelfModulate = new Color(1, 1, 1, 1);

            string[] states = ["normal", "hover", "pressed"];
            Color[] colors = [normalColor, hoverColor, pressedColor];

            for (int i = 0; i < states.Length; i++)
            {
                StyleBoxFlat styleBox = new() { BgColor = colors[i] };
                styleBox.SetCornerRadiusAll(5);
                privacyBtn.AddThemeStyleboxOverride(states[i], styleBox);
            }
        }

        public async void OnPrivacyToggleButtonPressed()
        {
            Button privacyBtn = _lobbyMenu?.PrivacyToggleButton;
            if (privacyBtn == null) return;

            bool targetPublicState = !SessionManager.Instance.IsPublic;
            privacyBtn.Disabled = true;

            bool success = await LobbyManagementService.UpdateLobbyPrivacyAsync(
                SessionManager.Instance.CurrentRoomCode,
                targetPublicState
            );

            if (success)
            {
                UpdateRoomInfoUI();
                UpdatePrivacyButtonVisual(targetPublicState);
            }
            else
            {
                UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);
            }

            privacyBtn.Disabled = false;
        }
    }
}