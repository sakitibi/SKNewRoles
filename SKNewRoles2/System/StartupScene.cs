using Godot;
using System;
using System.Threading.Tasks;

namespace SKNewRoles2.SNRSystem
{
    public partial class StartupScene : Control
    {
        public static bool IsGameLaunch { get; set; } = false;

        public static event Func<Action<float, string>, Task> OnModLoadingSequence;
        public static event Action<StartupScene> OnStartupVisualInitialized;

        private TextureProgressBar _progressBar;
        private Label _statusLabel;
        private Label _percentLabel;
        private ColorRect _background;

        private Tween _progressTween;

        public TextureProgressBar StartupProgressBar => _progressBar;
        public Label StatusLabel => _statusLabel;
        public ColorRect BackgroundRect => _background;

        public override void _Ready()
        {
            _background = GetNode<ColorRect>("Background");
            _statusLabel = GetNode<Label>("CenterContainer/VBoxContainer/LoadingLabel");
            _progressBar = GetNode<TextureProgressBar>("CenterContainer/VBoxContainer/StartupProgressBar");

            if (_progressBar.HasNode("PercentLabel"))
            {
                _percentLabel = _progressBar.GetNode<Label>("PercentLabel");
                _percentLabel.Text = "0%";
            }

            _progressBar.Value = 0;
            
            OnStartupVisualInitialized?.Invoke(this);

            _statusLabel.Text = "システムを初期化中...";

            _ = RunStartupSequenceAsync();
        }

        private async Task RunStartupSequenceAsync()
        {
            try
            {
                UpdateProgress(0, "システム環境を確認中...");
                await Task.Delay(200);

                await AssetDownloader.EnsureAssetsDownloadedAsync((ratio, text) =>
                {
                    float mappedVal = 10f + (ratio * 40f);
                    UpdateProgress(mappedVal, text);
                });

                if (!IsInstanceValid(this) || !IsInsideTree()) return;

                UpdateProgress(50, "コアモジュールをロード中...");
                await Task.Delay(200);
                if (!IsInstanceValid(this) || !IsInsideTree()) return;

                // Mod/拡張機能のロードシーケンス実行
                if (OnModLoadingSequence != null)
                {
                    Delegate[] invocationList = OnModLoadingSequence.GetInvocationList();
                    for (int i = 0; i < invocationList.Length; i++)
                    {
                        try
                        {
                            if (invocationList[i] is Func<Action<float, string>, Task> modTask)
                            {
                                await modTask.Invoke((val, text) => {
                                    float mappedVal = 55f + (val * 0.35f); 
                                    UpdateProgress(mappedVal, text);
                                });
                            }
                        }
                        catch (Exception ex)
                        {
                            GD.PrintErr($"❌ [Mod Load Error] インデックス {i}: {ex.Message}");
                        }
                    }
                }

                // 起動完了フェーズ
                UpdateProgress(95, "ゲーム環境を構築中...");
                await Task.Delay(300);

                if (!IsInstanceValid(this) || !IsInsideTree()) return;

                UpdateProgress(100, "準備完了！");
                await Task.Delay(300);

                if (GetTree() != null && GetTree().CurrentScene == this)
                {
                    GD.Print("[Startup] 全てのロードが完了しました。タイトル画面(Home.tscn)へ遷移します。");
                    Error error = GetTree().ChangeSceneToFile("res://Scenes/Home.tscn");
                    if (error != Error.Ok)
                    {
                        GD.PrintErr("❌ タイトル画面(Home.tscn)への遷移に失敗しました: " + error);
                    }
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ [Startup] シーケンス実行中にエラーが発生しました: {ex.Message}\n{ex.StackTrace}");
                if (GetTree() != null && GetTree().CurrentScene == this)
                {
                    GetTree().ChangeSceneToFile("res://Scenes/Home.tscn");
                }
            }
        }

        private void UpdateProgress(float targetValue, string statusText)
        {
            if (_statusLabel != null)
            {
                _statusLabel.Text = statusText;
            }

            if (_progressBar != null)
            {
                float startValue = (float)_progressBar.Value;

                if (_progressTween != null && _progressTween.IsValid())
                {
                    _progressTween.Kill();
                }

                _progressTween = CreateTween();
                
                _progressTween.TweenProperty(_progressBar, "value", targetValue, 0.25f)
                              .SetTrans(Tween.TransitionType.Sine)
                              .SetEase(Tween.EaseType.Out);

                if (_percentLabel != null)
                {
                    _progressTween.Parallel().TweenMethod(
                        Callable.From<float>(val => {
                            _percentLabel.Text = $"{Mathf.RoundToInt(val)}%";
                        }),
                        startValue,
                        targetValue,
                        0.25f
                    ).SetTrans(Tween.TransitionType.Sine)
                     .SetEase(Tween.EaseType.Out);
                }
            }
        }

        public override void _ExitTree()
        {
            if (_progressTween != null && _progressTween.IsValid())
            {
                _progressTween.Kill();
            }
            base._ExitTree();
        }
    }
}