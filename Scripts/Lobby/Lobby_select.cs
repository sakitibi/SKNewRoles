using Godot;
using SKNewRoles2.SessionManagerSystem;

public partial class Lobby_select : Control
{
    private Button _loginButton;
    private Button _logoutButton;
    private Button _backButton;
    private Button _createRoomButton;
    private Button _joinPublicRoomButton;
    private Button _joinPrivateRoomButton;
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
        _emailLabel = GetNode<Label>($"{basePath}EmailLabel");

        // イベントの接続
        _loginButton.Pressed += OnLoginButtonPressed;
        _logoutButton.Pressed += OnLogoutButtonPressed;
        _backButton.Pressed += OnBackButtonPressed;
        _createRoomButton.Pressed += OnCreateRoomButtonPressed;
        _joinPublicRoomButton.Pressed += OnJoinPublicRoomButtonPressed;
        _joinPrivateRoomButton.Pressed += OnJoinPrivateRoomButtonPressed;

        SessionManager.Instance.UserInfoUpdated += OnUserInfoUpdated;

        UpdateButtonStates();
    }

    public override void _ExitTree()
    {
        // ⚠️ メモリリーク防止のため、シーンが破棄される時にイベント接続を解除
        if (SessionManager.Instance != null)
        {
            SessionManager.Instance.UserInfoUpdated -= OnUserInfoUpdated;
        }
    }

    // 🔔 裏で本物のEmail（ユーザー情報）が同期されたら自動で呼ばれる
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

    private void OnLoginButtonPressed()
    {
        Error error = GetTree().ChangeSceneToFile("res://Scenes/Login.tscn");
        if (error != Error.Ok)
        {
            GD.PrintErr("シーンの切り替えに失敗しました: " + error);
        }
    }

    private void OnLogoutButtonPressed()
    {
        // ログアウト処理を実行（ファイル削除＆メモリクリア）
        SessionManager.Instance.ClearSession();
        
        // ボタンやテキストの状態を「未ログイン状態」に戻す
        UpdateButtonStates();
    }

    private void OnBackButtonPressed()
    {
        Error error = GetTree().ChangeSceneToFile("res://Scenes/Home.tscn");
        if (error != Error.Ok)
        {
            GD.PrintErr("シーンの切り替えに失敗しました: " + error);
        }
    }

    private void OnCreateRoomButtonPressed()
    {
        Error error = GetTree().ChangeSceneToFile("res://Scenes/CreateLobby.tscn");
        if (error != Error.Ok)
        {
            GD.PrintErr("シーンの切り替えに失敗しました: " + error);
        }
    }

    private void OnJoinPublicRoomButtonPressed()
    {
        Error error = GetTree().ChangeSceneToFile("res://Scenes/JoinPublicLobby.tscn");
        if (error != Error.Ok)
        {
            GD.PrintErr("シーンの切り替えに失敗しました: " + error);
        }
    }

    private void OnJoinPrivateRoomButtonPressed()
    {
        Error error = GetTree().ChangeSceneToFile("res://Scenes/JoinPrivateLobby.tscn");
        if (error != Error.Ok)
        {
            GD.PrintErr("シーンの切り替えに失敗しました: " + error);
        }
    }
}