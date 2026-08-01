using Godot;
using System;
using System.Text;
using SKNewRoles2.Lobby;
using SKNewRoles2.SessionManagerSystem;

public partial class CreateLobby : Control
{
    private LineEdit _lobbyNameInput;
    private Button _confirmButton;
    private Button _cancelButton;
    private Label _statusLabel;

    private const string AllowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    public override void _Ready()
    {
        _lobbyNameInput = GetNode<LineEdit>("MarginContainer/VBoxContainer/Panel/VBoxContainer/LobbyNameInput");
        _confirmButton = GetNode<Button>("MarginContainer/VBoxContainer/Panel/VBoxContainer/ConfirmButton");
        _cancelButton = GetNode<Button>("MarginContainer/VBoxContainer/Panel/VBoxContainer/CancelButton");
        _statusLabel = GetNode<Label>("MarginContainer/VBoxContainer/Panel/VBoxContainer/StatusLabel");

        _confirmButton.Pressed += OnConfirmButtonPressed;
        _cancelButton.Pressed += OnCancelButtonPressed;
        _lobbyNameInput.TextChanged += OnLobbyNameChanged;

        _statusLabel.Text = "";
        _confirmButton.Disabled = true;
    }

    private void OnLobbyNameChanged(string newText)
    {
        _confirmButton.Disabled = string.IsNullOrWhiteSpace(newText);
    }

    private async void OnConfirmButtonPressed()
    {
        string lobbyName = _lobbyNameInput.Text.Trim();
        string roomCode = GenerateRandomRoomCode(8);

        // 作成時点では強制的に非公開 (false) に設定します
        bool isPublic = false;
        

        _confirmButton.Disabled = true;
        _lobbyNameInput.Editable = false;

        _statusLabel.Text = "非公開ロビーを作成中...";
        GD.Print($"🛰️ ロビーを作成します(初期状態:非公開)... 名前: {lobbyName} [Code: {roomCode}]");

        bool success = await LobbySettings.CreateLobbyAsync(roomCode, lobbyName, isPublic);

        if (success)
        {
            GD.Print($"✅ ロビーの作成に成功しました。コード: {roomCode}");
            _statusLabel.Text = "作成成功！移動します...";

            SessionManager.Instance.CurrentRoomCode = roomCode;
            SessionManager.Instance.CurrentRoomName = lobbyName;
            SessionManager.Instance.IsHost = true; 
            SessionManager.Instance.IsPublic = isPublic; // 非公開(false)を記憶

            await ToSignal(GetTree().CreateTimer(1.0f), "timeout");
            GetTree().ChangeSceneToFile("res://Scenes/LobbyRoom3D.tscn");
        }
        else
        {
            GD.PrintErr("❌ ロビー作成に失敗しました。");
            _statusLabel.Text = "作成に失敗しました。もう一度お試しください。";
            _confirmButton.Disabled = false;
            _lobbyNameInput.Editable = true;
        }
    }

    private void OnCancelButtonPressed()
    {
        GetTree().ChangeSceneToFile("res://Scenes/Lobby_select.tscn");
    }

    private string GenerateRandomRoomCode(int length)
    {
        var random = new Random();
        var result = new StringBuilder(length);
        for (int i = 0; i < length; i++)
        {
            result.Append(AllowedChars[random.Next(AllowedChars.Length)]);
        }
        return result.ToString();
    }
}