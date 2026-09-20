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

                _skinModelContainer.AddChild(dummyInstance);

                dummyInstance.Call("set_target_transform", 0f, 0f, 0f, 0f, 0f, 0f);

                // 現在の物理位置・回転も直接 0 に強制リセット
                dummyInstance.GlobalPosition = Vector3.Zero;
                dummyInstance.GlobalRotation = Vector3.Zero;

                // 念のため物理処理を無効化
                dummyInstance.SetPhysicsProcess(false);
                dummyInstance.SetProcess(false);

                // SkinPainterの初期化
                GetNodeOrNull<SkinPainter>("SkinPainter")?.Initialize(dummyInstance);
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