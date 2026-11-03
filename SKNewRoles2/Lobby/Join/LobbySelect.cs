using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.BGM;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.SNRSystem;

namespace SKNewRoles2.Lobby.JOIN
{
    public partial class LobbySelect : Control
    {
        private Button _loginButton;
        private Button _logoutButton;
        private Button _backButton;
        private Button _createRoomButton;
        private Button _joinPublicRoomButton;
        private Button _joinPrivateRoomButton;
        private Button _skinEditButton;
        private ButtonAnimation _buttonAnimation;
        private BGMManager _bgmManager;
        private Label _emailLabel;

        public override void _Ready()
        {
            const string basePath = "MarginContainer/VBoxContainer/LobbySelectPanel/";

            _loginButton = GetNode<Button>($"{basePath}LoginButton");
            _logoutButton = GetNode<Button>($"{basePath}LogoutButton");
            _backButton = GetNode<Button>($"{basePath}BackButton");
            _createRoomButton = GetNode<Button>($"{basePath}CreateRoomButton");
            _joinPublicRoomButton = GetNode<Button>($"{basePath}JoinPublicRoomButton");
            _joinPrivateRoomButton = GetNode<Button>($"{basePath}JoinPrivateRoomButton");
            _skinEditButton = GetNode<Button>($"{basePath}SkinEditButton");
            _buttonAnimation = GetNode<ButtonAnimation>("ButtonAnimation");
            _bgmManager = GetNode<BGMManager>("BGMManager");
            _emailLabel = GetNode<Label>($"{basePath}EmailLabel");

            // イベントの接続
            _loginButton.Pressed += OnLoginButtonPressed;
            _logoutButton.Pressed += OnLogoutButtonPressed;
            _backButton.Pressed += OnBackButtonPressed;
            _createRoomButton.Pressed += OnCreateRoomButtonPressed;
            _joinPublicRoomButton.Pressed += OnJoinPublicRoomButtonPressed;
            _joinPrivateRoomButton.Pressed += OnJoinPrivateRoomButtonPressed;
            _skinEditButton.Pressed += OnSkinEditButtonPressed;

            _buttonAnimation.SetupButtonAnimation(_loginButton);
            _buttonAnimation.SetupButtonAnimation(_logoutButton);
            _buttonAnimation.SetupButtonAnimation(_backButton);
            _buttonAnimation.SetupButtonAnimation(_createRoomButton);
            _buttonAnimation.SetupButtonAnimation(_joinPublicRoomButton);
            _buttonAnimation.SetupButtonAnimation(_joinPrivateRoomButton);
            _buttonAnimation.SetupButtonAnimation(_skinEditButton);

            SessionManager.Instance.UserInfoUpdated += OnUserInfoUpdated;

            UpdateButtonStates();
        }

        public override void _ExitTree()
        {
            // メモリリーク防止のため、シーンが破棄される時にイベント接続を解除
            if (SessionManager.Instance != null)
            {
                SessionManager.Instance.UserInfoUpdated -= OnUserInfoUpdated;
            }
        }

        private void OnUserInfoUpdated()
        {
            // データが更新されたので画面をリフレッシュ
            UpdateButtonStates();
        }

        private void UpdateButtonStates()
        {
            // SessionManager を見てログイン中かどうかを判断
            bool isLoggedIn = SessionManager.Instance.IsLoggedIn;

            _loginButton.Disabled = isLoggedIn;      // ログイン済なら押せない
            _logoutButton.Disabled = !isLoggedIn;    // ログイン済なら押せる
            _createRoomButton.Disabled = !isLoggedIn; // ログイン済なら押せる
            // ラベルがある場合、Emailの表示も連動させる
            if (_emailLabel != null)
            {
                if (isLoggedIn && SessionManager.Instance.CurrentSession.User != null)
                {
                    string email = SessionManager.Instance.CurrentSession.User.Email;
                    _emailLabel.Text = (email == "Authenticating...") ? "ログイン情報を取得中..." : $"{email}";
                }
                else
                {
                    _emailLabel.Text = "未ログイン";
                }
            }
        }

        private async void OnLoginButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            Error error = GetTree().ChangeSceneToFile("res://Scenes/Login.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }

        private async void OnLogoutButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            // ログアウト処理を実行（ファイル削除＆メモリクリア）
            SessionManager.Instance.ClearSession();
            
            // ボタンやテキストの状態を「未ログイン状態」に戻す
            UpdateButtonStates();
        }

        private async void OnBackButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            Error error = GetTree().ChangeSceneToFile("res://Scenes/Home.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }

        private async void OnCreateRoomButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            Error error = GetTree().ChangeSceneToFile("res://Scenes/CreateLobby.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }

        private async void OnJoinPublicRoomButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            Error error = GetTree().ChangeSceneToFile("res://Scenes/JoinPublicLobby.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }

        private async void OnJoinPrivateRoomButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            Error error = GetTree().ChangeSceneToFile("res://Scenes/JoinPrivateLobby.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }

        private async void OnSkinEditButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            Error error = GetTree().ChangeSceneToFile("res://Scenes/SkinEditScene.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }
    }
}