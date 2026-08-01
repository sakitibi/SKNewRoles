using Godot;
using System;
using SKNewRoles2.Lobby.JOIN;

public partial class JoinPrivateLobby : Control
{
    private LineEdit _roomCodeEdit;
    private Button _joinButton;
    private Button _cancelButton;

    public override void _Ready()
    {
        _roomCodeEdit = GetNode<LineEdit>("%RoomCodeEdit");
        _joinButton = GetNode<Button>("%JoinButton");
        _cancelButton = GetNode<Button>("%CancelButton");

        // ボタンのクリックイベントを関数に接続
        _joinButton.Pressed += OnJoinButtonPressed;
        _cancelButton.Pressed += OnCancelButtonPressed;

        // 入力欄でEnterキーを押したときも参加処理を走らせる
        _roomCodeEdit.TextSubmitted += (text) => OnJoinButtonPressed();
    }

    private async void OnJoinButtonPressed()
    {
        // 入力された文字を取得（前後の空白を消し、小文字で入力されても大文字に統一）
        string roomCode = _roomCodeEdit.Text.Trim().ToUpper();

        // バリデーションチェック
        if (string.IsNullOrEmpty(roomCode))
        {
            GD.Print("⚠️ 部屋コードが入力されていません！");
            return;
        }

        // 処理中の連打・多重送信を防止するためにUIを無効化
        SetUiEnabled(false);
        GD.Print($"🔍 部屋コード [{roomCode}] のロビーを探しています...");

        try
        {
            bool success = await Http.JoinLobbyAsync(roomCode);

            if (success)
            {
                GD.Print("✅ 入室成功！待機室（LobbyRoom3D）へ移動します。");
                GetTree().ChangeSceneToFile("res://Scenes/LobbyRoom3D.tscn");
            }
            else
            {
                GD.PrintErr("❌ ロビーが見つからないか、満員で入室できませんでした。");
                // 失敗した場合は再度入力・ボタン押しができるように戻す
                SetUiEnabled(true);
            }
        }
        catch (Exception ex)
        {
            GD.PrintErr($"❌ 通信中にエラーが発生しました: {ex.Message}");
            SetUiEnabled(true);
        }
    }

    private void OnCancelButtonPressed()
    {
        GD.Print("🔙 ロビー選択画面に戻ります。");
        GetTree().ChangeSceneToFile("res://Scenes/Lobby_select.tscn");
    }

    /// <summary>
    /// 通信中のボタンや入力欄の有効・無効を一括切り替えするヘルパー関数
    /// </summary>
    private void SetUiEnabled(bool enabled)
    {
        _joinButton.Disabled = !enabled;
        _cancelButton.Disabled = !enabled;
        _roomCodeEdit.Editable = enabled; // 通信中は文字を入力できないようにする
    }
}