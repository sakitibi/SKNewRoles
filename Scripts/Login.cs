using Godot;
using System;
using System.Text.Json;
using SKNewRoles2.SessionManagerSystem;

public partial class Login : Control
{
    private LineEdit _codeInput;
    private Button _submitButton;
    private Button _cancelButton;
    private Label _errorMessageLabel;
    private HttpRequest _supabaseRequest;
    public override void _Ready()
    {
        // 全て LoginPanel の直下から取得
        _codeInput = GetNode<LineEdit>("MarginContainer/VBoxContainer/LoginPanel/CodeInput");
        _submitButton = GetNode<Button>("MarginContainer/VBoxContainer/LoginPanel/SubmitButton");
        _cancelButton = GetNode<Button>("MarginContainer/VBoxContainer/LoginPanel/CancelButton");
        _errorMessageLabel = GetNode<Label>("MarginContainer/VBoxContainer/LoginPanel/ErrorMessageLabel");
        
        // HTTPRequestノードの取得
        _supabaseRequest = GetNode<HttpRequest>("SupabaseRequest");
        
        // シグナル接続
        _supabaseRequest.RequestCompleted += OnSupabaseRequestCompleted;
        _submitButton.Pressed += OnSubmitButtonPressed;
        _cancelButton.Pressed += OnCancelButtonPressed;
        _codeInput.TextChanged += OnInputTextChanged;
        
        _errorMessageLabel.Text = "";
        _submitButton.Disabled = true;
    }

    private void OnInputTextChanged(string newText)
    {
        _errorMessageLabel.Text = "";
        _submitButton.Disabled = (newText.Length != 8);
    }

    private void OnSubmitButtonPressed()
    {
        _submitButton.Disabled = true;
        _codeInput.Editable = false;
        _errorMessageLabel.Text = "認証中...";

        string inputCode = _codeInput.Text.Trim();
        string url = $"{SessionManager.SupabaseUrl}/rest/v1/app_links?select=*&code=eq.{inputCode}";

        string[] headers = new string[]
        {
            $"apikey: {SessionManager.SupabaseAnonKey}",
            $"Authorization: Bearer {SessionManager.SupabaseAnonKey}",
            "Accept: application/json"
        };

        // 名前付き引数を使って、GETメソッドと空のボディを確実にGodotへ伝える
        Error err = _supabaseRequest.Request(
            url: url,
            customHeaders: headers,
            method: HttpClient.Method.Get,
            requestData: "" // これを明示することで、POSTへの自動変換バグを回避します
        );
        
        if (err != Error.Ok)
        {
            ShowError("リクエストの送信に失敗しました。");
        }
    }

    private void OnSupabaseRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        string jsonText = body != null ? System.Text.Encoding.UTF8.GetString(body) : "";
        
        if (result != (long)HttpRequest.Result.Success)
        {
            ShowError("ネットワークエラーが発生しました。");
            return;
        }

        // Supabaseは成功時（データ取得・空でも）基本的に 200 OK を返します
        if (responseCode != 200)
        {
            GD.PrintErr($"❌ 【サーバーエラー】HTTPステータスコード: {responseCode}");
            GD.PrintErr($"📄 エラーレスポンス詳細:\n{jsonText}");
            
            ShowError($"サーバーエラーが発生しました (Code: {responseCode})");
            return;
        }
        
        try
        {
            var records = JsonSerializer.Deserialize<AppLinkRecord[]>(jsonText);

            if (records != null && records.Length > 0)
            {
                AppLinkRecord rawRecord = records[0];

                SessionData session = new SessionData
                {
                    AccessToken = rawRecord.AccessToken,
                    RefreshToken = rawRecord.RefreshToken,
                    TokenType = "bearer",
                    ExpiresIn = 3600
                };

                session.User = new UserInfo
                {
                    Id = rawRecord.UserId,
                    Email = "Authenticating..." 
                };

                if (!string.IsNullOrEmpty(session.AccessToken))
                {
                    // グローバルセッションマネージャーへ格納（自動的にファイル保存が走る）
                    SessionManager.Instance.SetSession(session);

                    // シーンの切り替え
                    Error error = GetTree().ChangeSceneToFile("res://Scenes/Lobby_select.tscn");
                    if (error != Error.Ok)
                    {
                        GD.PrintErr("シーンの切り替えに失敗しました: " + error);
                    }
                }
                else
                {
                    ShowError("セッションデータの取得に失敗しました。");
                }
            }
            else
            {
                ShowError("該当する認証コードが見つかりません。");
            }
        }
        catch (Exception ex)
        {
            GD.PrintErr($"JSONパースエラー: {ex.Message}");
            GD.PrintErr($"受信データの生テキスト: {jsonText}");
            ShowError("データの解析に失敗しました。");
        }
    }

    private void ShowError(string message)
    {
        _errorMessageLabel.Text = message;
        _submitButton.Disabled = (_codeInput.Text.Length != 8);
        _codeInput.Editable = true;
    }

    private void OnCancelButtonPressed()
    {
        QueueFree();
    }
}