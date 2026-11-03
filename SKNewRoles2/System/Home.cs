using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.BGM;

namespace SKNewRoles2.SNRSystem
{
    public partial class Home : Control
    {
        private Button _startButton;
        private Button _exitButton;
        private ButtonAnimation _buttonAnimation;
        private readonly BGMManager _bgmManager = new();
        private readonly uint[] BGMList = [
            1, 2, 3,
        ];

        public override void _Ready()
        {
            string basePath = "MarginContainer/VBoxContainer/HomePanel/";
            
            // 各ボタンノードを取得
            _buttonAnimation = GetNode<ButtonAnimation>("ButtonAnimation");
            _startButton = GetNode<Button>(basePath + "StartButton");
            _exitButton = GetNode<Button>(basePath + "ExitButton");

            // ボタンアニメーションのセットアップ
            _buttonAnimation.SetupButtonAnimation(_startButton);
            _buttonAnimation.SetupButtonAnimation(_exitButton);

            // ボタンのクリックイベントを紐付け
            _startButton.Pressed += OnStartButtonPressed;
            _exitButton.Pressed += QuitGame;

            AddChild(_bgmManager);

            _ = _bgmManager.PlayBgm(1.0f, BGMList);
        }

        private async void OnStartButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            string storyScenePath = "res://Scenes/StoryReader.tscn";

            Error error = GetTree().ChangeSceneToFile(storyScenePath);
            
            if (error != Error.Ok)
            {
                GD.PrintErr("シーンの切り替えに失敗しました: " + error);
            }
        }

        private async void QuitGame()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            GetTree().Quit();
        }
    }
}