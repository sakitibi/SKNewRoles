using Godot;

namespace SKNewRoles2.SNRSystem
{
    public partial class Home : Control
    {
        private Button _startButton;
        private Button _exitButton;

        public override void _Ready()
        {
            string basePath = "MarginContainer/VBoxContainer/HomePanel/";
            
            // 各ボタンノードを取得
            _startButton = GetNode<Button>(basePath + "StartButton");
            _exitButton = GetNode<Button>(basePath + "ExitButton");

            // ボタンアニメーションのセットアップ
            SetupButtonAnimation(_startButton);
            SetupButtonAnimation(_exitButton);

            // ボタンのクリックイベントを紐付け
            _startButton.Pressed += OnStartButtonPressed;
            _exitButton.Pressed += QuitGame;
        }

        /// <summary>
        /// ボタンにホバー時・押下時の滑らかな拡大縮小アニメーションを設定
        /// </summary>
        private void SetupButtonAnimation(Button button)
        {
            button.PivotOffset = button.Size / 2;

            // マウスホバー時
            button.MouseEntered += () => AnimateScale(button, new Vector2(1.08f, 1.08f), 0.1f);
            // マウス離脱時
            button.MouseExited += () => AnimateScale(button, Vector2.One, 0.1f);
            // ボタンを押した瞬間
            button.ButtonDown += () => AnimateScale(button, new Vector2(0.95f, 0.95f), 0.05f);
            // ボタンを離した時
            button.ButtonUp += () => AnimateScale(button, new Vector2(1.08f, 1.08f), 0.05f);
        }

        /// <summary>
        /// Tweenを使ってスケールを変更する共通メソッド
        /// </summary>
        private void AnimateScale(Button button, Vector2 targetScale, double duration)
        {
            Tween tween = CreateTween().SetTrans(Tween.TransitionType.Sine).SetEase(Tween.EaseType.Out);
            tween.TweenProperty(button, "scale", targetScale, duration);
        }

        private void OnStartButtonPressed()
        {
            string storyScenePath = "res://Scenes/StoryReader.tscn";

            Error error = GetTree().ChangeSceneToFile(storyScenePath);
            
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
}