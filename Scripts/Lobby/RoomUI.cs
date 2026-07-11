using Godot;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN;

namespace SKNewRoles2.Lobby
{
    public partial class RoomUI
    {
        private readonly LobbyRoom _lobbyRoom;

        public RoomUI(LobbyRoom lobbyRoom)
        {
            _lobbyRoom = lobbyRoom;
        }

        /// <summary>
        /// 現在のルーム名と部屋コードをUIラベルに即座に反映します。
        /// </summary>
        public void UpdateRoomInfoUI()
        {
            if (_lobbyRoom?.RoomInfoLabel == null) return;

            string roomName = SessionManager.Instance.CurrentRoomName;
            string roomCode = SessionManager.Instance.CurrentRoomCode;
            _lobbyRoom.RoomInfoLabel.Text = $"ルーム名: {roomName}\n部屋コード: {roomCode}";
        }

        /// <summary>
        /// ホストが「ゲーム開始」ボタンを押したときの処理（データベース側ロビーを非アクティブ化）
        /// </summary>
        public async void OnStartGameButtonPressed()
        {
            if (_lobbyRoom.StartGameButton != null)
            {
                _lobbyRoom.StartGameButton.Disabled = true;
            }

            GD.Print("🎬 ホストがゲームを開始しました。Supabaseのロビーを非アクティブ化して全員の画面を一斉遷移させます...");
            bool success = await LobbySettings.CloseLobbyAsync(SessionManager.Instance.CurrentRoomCode);

            if (success)
            {
                GD.Print("✅ ホスト側のロビー非アクティブ化に成功しました。ホスト自身もメインステージへ遷移します。");
                _lobbyRoom.TransitionToGameStage();
            }
            else
            {
                GD.PrintErr("❌ ロビーの非アクティブ化（ゲーム開始処理）に失敗しました。");
                if (_lobbyRoom.StartGameButton != null)
                {
                    _lobbyRoom.StartGameButton.Disabled = false;
                }
            }
        }

        /// <summary>
        /// サーバー上のロビーテーブルの変更通知をリアルタイムに検知した時の処理
        /// </summary>
        public async void OnRoomSettingsChangedFromServer()
        {
            string currentCode = SessionManager.Instance.CurrentRoomCode;
            if (string.IsNullOrEmpty(currentCode)) return;

            GD.Print("🔄 サーバー上のロビーデータ更新をリアルタイム検知。ステータスを検証中...");
            int lobbyStatus = await Http.CheckLobbyStatusAsync(currentCode);
            
            if (lobbyStatus == 0)
            {
                UpdateRoomInfoUI();
                UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);
            }
            else if (lobbyStatus == 1)
            {
                GD.Print("🚀 【ゲーム開始フラグ検知】全員同時にメインステージ「MainGameScene」に遷移します！");
                _lobbyRoom.TransitionToGameStage();
            }
            else
            {
                GD.PrintErr("❌ 部屋データが削除されたか、ロビーが解散されました。タイトルセレクトに戻ります。");
                _lobbyRoom.LeaveLobbyForced();
            }
        }

        /// <summary>
        /// 公開状態（is_public）に応じて、トグルボタンのテキストとテーマ色（スタイルボックス）を即座に書き換えます。
        /// </summary>
        public void UpdatePrivacyButtonVisual(bool isPublic)
        {
            if (_lobbyRoom.PrivacyToggleButton == null) return;

            Color normalColor;
            Color hoverColor;
            Color pressedColor;

            if (isPublic)
            {
                _lobbyRoom.PrivacyToggleButton.Text = "公開中";
                normalColor  = RoomColorData.PublicNormalColor;
                hoverColor   = RoomColorData.PublicHoverColor;
                pressedColor = RoomColorData.PublicPressedColor;
            }
            else
            {
                _lobbyRoom.PrivacyToggleButton.Text = "非公開";
                normalColor  = RoomColorData.PrivateNormalColor;
                hoverColor   = RoomColorData.PrivateHoverColor;
                pressedColor = RoomColorData.PrivatePressedColor;
            }

            _lobbyRoom.PrivacyToggleButton.SelfModulate = new Color(1, 1, 1, 1);

            string[] states = ["normal", "hover", "pressed"];
            Color[] colors = [normalColor, hoverColor, pressedColor];

            for (int i = 0; i < states.Length; i++)
            {
                var styleBox = new StyleBoxFlat();
                styleBox.BgColor = colors[i];
                styleBox.SetCornerRadiusAll(5);
                _lobbyRoom.PrivacyToggleButton.AddThemeStyleboxOverride(states[i], styleBox);
            }
        }

        /// <summary>
        /// 公開/非公開ボタンを押した際、サーバー側のデータベースに変更パッチを送信します。
        /// </summary>
        public async void OnPrivacyToggleButtonPressed()
        {
            if (_lobbyRoom.PrivacyToggleButton == null) return;

            bool targetPublicState = !SessionManager.Instance.IsPublic;
            GD.Print($"🌐 部屋の公開設定をボタンからリクエスト中... 変更先: {targetPublicState}");
            _lobbyRoom.PrivacyToggleButton.Disabled = true;

            bool success = await Http.UpdateLobbyPrivacyAsync(
                SessionManager.Instance.CurrentRoomCode,
                targetPublicState
            );

            if (success)
            {
                GD.Print($"✅ 部屋の公開設定を正常に更新しました：{(targetPublicState ? "公開" : "非公開")}");
                UpdateRoomInfoUI();
                UpdatePrivacyButtonVisual(targetPublicState);
            }
            else
            {
                GD.PrintErr("❌ 部屋の公開設定更新に失敗しました。以前のビジュアルに戻します。");
                UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);
            }

            _lobbyRoom.PrivacyToggleButton.Disabled = false;
        }
    }
}