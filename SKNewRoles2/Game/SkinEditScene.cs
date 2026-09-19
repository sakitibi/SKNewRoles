using Godot;

namespace SKNewRoles2.Game
{
    public partial class SkinEditScene : Node3D
    {
        private Button _backButton;
        private Button _saveButton;
        private Node3D _skinModelContainer;

        private const string DummyScenePath = "res://Scenes/Prefabs/LobbyPlayerDummy.tscn";
        private const string LobbySelectScenePath = "res://Scenes/LobbySelect.tscn";

        public override void _Ready()
        {
            // UIノードの参照取得
            const string uiPath = "CanvasLayer/Control/MarginContainer/VBoxContainer/";
            _backButton = GetNode<Button>($"{uiPath}BackButton");
            _saveButton = GetNode<Button>($"{uiPath}SaveButton");
            _skinModelContainer = GetNode<Node3D>("SkinModelContainer");

            // シグナル（イベント）接続
            _backButton.Pressed += OnBackButtonPressed;
            _saveButton.Pressed += OnSaveButtonPressed;

            // プレビュー表示用ダミーモデルの読み込み
            LoadPlayerPreview();
        }

        private void LoadPlayerPreview()
        {
            var dummyScene = GD.Load<PackedScene>(DummyScenePath);
            if (dummyScene != null)
            {
                var dummyInstance = dummyScene.Instantiate<Node3D>();

                // 物理演算（重力等）を無効化して落下を防ぐ
                dummyInstance.SetPhysicsProcess(false);
                dummyInstance.SetProcess(false);

                // 位置を原点にリセット
                dummyInstance.Position = Vector3.Zero;

                _skinModelContainer.AddChild(dummyInstance);

                // SkinPainterの初期化呼び出し
                var painter = GetNodeOrNull<SkinPainter>("SkinPainter");
                painter?.Initialize(dummyInstance);
            }
            else
            {
                GD.PrintErr($"[SkinEdit] ダミーモデルのロードに失敗しました: {DummyScenePath}");
            }
        }

        private void OnSaveButtonPressed()
        {
            GD.Print("[SkinEdit] 保存ボタンが押されました");
        }

        private void OnBackButtonPressed()
        {
            Error error = GetTree().ChangeSceneToFile(LobbySelectScenePath);
            if (error != Error.Ok)
            {
                GD.PrintErr($"[SkinEdit] シーン遷移失敗: {error}");
            }
        }
    }
}