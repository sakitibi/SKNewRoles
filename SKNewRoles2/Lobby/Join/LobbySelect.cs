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
		private SessionManager _sessionManager;
		private Label _emailLabel;
		private readonly uint[] _buttonClickSoundIdx = [5];

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

			UpdateButtonStates();
			_sessionManager = SessionManager.Instance;
			if (_sessionManager != null)
			{
				_sessionManager.UserInfoUpdated += OnUserInfoUpdated;
				UpdateButtonStates();
			}
		}

		public override void _ExitTree()
		{
			_sessionManager?.UserInfoUpdated -= OnUserInfoUpdated;

			_loginButton.Pressed -= OnLoginButtonPressed;
			_logoutButton.Pressed -= OnLogoutButtonPressed;
			_backButton.Pressed -= OnBackButtonPressed;
			_createRoomButton.Pressed -= OnCreateRoomButtonPressed;
			_joinPublicRoomButton.Pressed -= OnJoinPublicRoomButtonPressed;
			_joinPrivateRoomButton.Pressed -= OnJoinPrivateRoomButtonPressed;
			_skinEditButton.Pressed -= OnSkinEditButtonPressed;
		}

		private void OnUserInfoUpdated()
		{
			UpdateButtonStates();
		}

		private void UpdateButtonStates()
		{
			bool isLoggedIn = _sessionManager.IsLoggedIn;

			_loginButton.Disabled = isLoggedIn;
			_logoutButton.Disabled = !isLoggedIn;
			_createRoomButton.Disabled = !isLoggedIn;

			if (_emailLabel != null)
			{
				if (isLoggedIn && _sessionManager.CurrentSession?.User != null)
				{
					string email = _sessionManager.CurrentSession.User.Email;
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
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			await Task.Delay(250);
			Error error = GetTree().ChangeSceneToFile("res://Scenes/Login.tscn");
			if (error != Error.Ok)
			{
				GD.PrintErr("シーンの切り替えに失敗しました: " + error);
			}
		}

		private async void OnLogoutButtonPressed()
		{
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			_sessionManager.ClearSession();
			UpdateButtonStates();
		}

		private async void OnBackButtonPressed()
		{
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			await Task.Delay(250);
			Error error = GetTree().ChangeSceneToFile("res://Scenes/Home.tscn");
			if (error != Error.Ok)
			{
				GD.PrintErr("シーンの切り替えに失敗しました: " + error);
			}
		}

		private async void OnCreateRoomButtonPressed()
		{
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			await Task.Delay(250);
			Error error = GetTree().ChangeSceneToFile("res://Scenes/CreateLobby.tscn");
			if (error != Error.Ok)
			{
				GD.PrintErr("シーンの切り替えに失敗しました: " + error);
			}
		}

		private async void OnJoinPublicRoomButtonPressed()
		{
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			await Task.Delay(250);
			Error error = GetTree().ChangeSceneToFile("res://Scenes/JoinPublicLobby.tscn");
			if (error != Error.Ok)
			{
				GD.PrintErr("シーンの切り替えに失敗しました: " + error);
			}
		}

		private async void OnJoinPrivateRoomButtonPressed()
		{
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			await Task.Delay(250);
			Error error = GetTree().ChangeSceneToFile("res://Scenes/JoinPrivateLobby.tscn");
			if (error != Error.Ok)
			{
				GD.PrintErr("シーンの切り替えに失敗しました: " + error);
			}
		}

		private async void OnSkinEditButtonPressed()
		{
			_ = _bgmManager.PlayBgm(2.0f, _buttonClickSoundIdx, false);
			await Task.Delay(250);
			Error error = GetTree().ChangeSceneToFile("res://Scenes/SkinEditScene.tscn");
			if (error != Error.Ok)
			{
				GD.PrintErr("シーンの切り替えに失敗しました: " + error);
			}
		}
	}
}