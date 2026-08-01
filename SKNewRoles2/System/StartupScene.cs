using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game.Network;

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
        private readonly RealtimeConnection _connection = new();

        private Tween _progressTween;

        public TextureProgressBar StartupProgressBar => _progressBar;
        public Label StatusLabel => _statusLabel;
        public ColorRect BackgroundRect => _background;

        public override async void _Ready()
        {
            _background = GetNode<ColorRect>("Background");
            _statusLabel = GetNode<Label>("CenterContainer/VBoxContainer/LoadingLabel");
            _progressBar = GetNode<TextureProgressBar>("CenterContainer/VBoxContainer/StartupProgressBar");

            // PercentLabel の参照を取得
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
            // 基本システムの準備
            UpdateProgress(10, "セッション情報を準備中...");
            await Task.Delay(200);
            if (!IsInstanceValid(this) || !IsInsideTree()) return;

            UpdateProgress(30, "ネットワーク接続を確保中...");
            bool isConnected = await _connection.EnsureConnectedAsync();
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
            await Task.Delay(400);

            if (!IsInstanceValid(this) || !IsInsideTree())
            {
                GD.Print("[Startup] バックグラウンドロード中断（既に別の画面へ遷移済み）。");
                return;
            }

            UpdateProgress(100, "準備完了！");
            
            await Task.Delay(400);

            if (!IsInstanceValid(this) || !IsInsideTree())
            {
                GD.Print("[Startup] 画面遷移をスキップ（既に別の画面へ遷移済み）。");
                return;
            }

            if (GetTree() != null && GetTree().CurrentScene == this)
            {
                GD.Print("[Startup] 全てのロードが完了しました。タイトル画面(Home.tscn)へ遷移します。");
                Error error = GetTree().ChangeSceneToFile("res://Scenes/Home.tscn");
                if (error != Error.Ok)
                {
                    GD.PrintErr("❌ タイトル画面(Home.tscn)への遷移に失敗しました: " + error);
                }
            }
            else
            {
                GD.Print("[Startup] 他のシーンの子ノード(UI)として実行されたため、画面遷移をスキップします。");
            }
        }

        /// <summary>
        /// 進捗バーとパーセンテージのテキストをTweenで滑らかにアニメーション更新
        /// </summary>
        private void UpdateProgress(float targetValue, string statusText)
        {
            if (_statusLabel != null)
            {
                _statusLabel.Text = statusText;
            }

            if (_progressBar != null)
            {
                float startValue = (float)_progressBar.Value;

                // 進行中の既存Tweenがあればキャンセル
                if (_progressTween != null && _progressTween.IsValid())
                {
                    _progressTween.Kill();
                }

                // 新しいTweenを開始
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
    }
}