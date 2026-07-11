using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.Game;

namespace SKNewRoles2.SNRSystem
{
    public partial class StartupScene : Control
    {
        public static bool IsGameLaunch { get; set; } = false;

        public static event Func<Action<float, string>, Task> OnModLoadingSequence;
        public static event Action<StartupScene> OnStartupVisualInitialized;

        private ProgressBar _progressBar;
        private Label _statusLabel;
        private ColorRect _background;

        public ProgressBar StartupProgressBar => _progressBar;
        public Label StatusLabel => _statusLabel;
        public ColorRect BackgroundRect => _background;

        public override async void _Ready()
        {
            // GetNode<T> で厳密にノードを参照（パスと型の一致）
            _background = GetNode<ColorRect>("Background");
            _statusLabel = GetNode<Label>("CenterContainer/VBoxContainer/LoadingLabel");
            _progressBar = GetNode<ProgressBar>("CenterContainer/VBoxContainer/StartupProgressBar");

            _progressBar.Value = 0;
            
            OnStartupVisualInitialized?.Invoke(this);

            _statusLabel.Text = "システムを初期化中...";

            _ = RunStartupSequenceAsync();
        }

        private async Task RunStartupSequenceAsync()
        {
            // 1. 基本システムの準備
            UpdateProgress(10, "セッション情報を準備中...");
            await Task.Delay(200);
            if (!IsInstanceValid(this) || !IsInsideTree()) return;

            UpdateProgress(30, "ネットワーク接続を確保中...");
            bool isConnected = await Realtime.EnsureConnectedAsync();
            if (!IsInstanceValid(this) || !IsInsideTree()) return;

            UpdateProgress(50, "コアモジュールをロード中...");
            await Task.Delay(200);
            if (!IsInstanceValid(this) || !IsInsideTree()) return;

            // 2. Mod/拡張機能のロードシーケンス実行
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

            // 3. 起動完了フェーズ
            UpdateProgress(95, "ゲーム環境を構築中...");
            await Task.Delay(400);

            if (!IsInstanceValid(this) || !IsInsideTree())
            {
                GD.Print("[Startup] バックグラウンドロード中断（既に別の画面へ遷移済み）。");
                return;
            }

            UpdateProgress(100, "準備完了！");
            await Task.Delay(200);

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

        private void UpdateProgress(float value, string statusText)
        {
            if (_progressBar != null) _progressBar.Value = value;
            if (_statusLabel != null) _statusLabel.Text = statusText;
        }
    }
}