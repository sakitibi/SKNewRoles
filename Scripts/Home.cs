using Godot;

public partial class Home : Control
{
    private Button _startButton;
    private Button _exitButton;

    public override void _Ready()
    {
        // HomeSceneの階層構造に合わせた正確なパス
        string basePath = "MarginContainer/VBoxContainer/HomePanel/";
        
        // 各ボタンノードを取得
        _startButton = GetNode<Button>(basePath + "StartButton");
        _exitButton = GetNode<Button>(basePath + "ExitButton");

        // ボタンのクリックイベントを紐付け
        _startButton.Pressed += OnStartButtonPressed;
        _exitButton.Pressed += QuitGame;
    }

    private void OnStartButtonPressed()
    {
        // ロビー選択画面へシーンを切り替え
        Error error = GetTree().ChangeSceneToFile("res://Scenes/Lobby_select.tscn");
        
        if (error != Error.Ok)
        {
            GD.PrintErr("シーンの切り替えに失敗しました: " + error);
        }
    }

    private void QuitGame()
    {
        GetTree().Quit();
    }
}