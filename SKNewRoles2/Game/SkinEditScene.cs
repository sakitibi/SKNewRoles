using Godot;

namespace SKNewRoles2.Game
{
    public partial class SkinEditScene : Node3D
    {
        private Button _backButton;
        private Button _saveButton;
        private Node3D _skinModelContainer;
        private FileDialog _fileDialog;

        private string _selectedPartName = "";

        private const string DummyScenePath = "res://Scenes/Prefabs/LobbyPlayerDummy.tscn";
        private const string LobbySelectScenePath = "res://Scenes/LobbySelect.tscn";

        private bool _isDragging = false;
        [Export] private float _rotateSensitivity = 0.005f;

        public override void _Ready()
        {
            const string uiPath = "CanvasLayer/Control/MarginContainer/VBoxContainer/";
            _backButton = GetNode<Button>($"{uiPath}BackButton");
            _saveButton = GetNode<Button>($"{uiPath}SaveButton");
            _skinModelContainer = GetNode<Node3D>("SkinModelContainer");

            // FileDialog の取得とイベント設定
            _fileDialog = GetNodeOrNull<FileDialog>("CanvasLayer/Control/FileDialog");
            if (_fileDialog != null)
            {
                _fileDialog.FileSelected += OnImageFileSelected;
            }

            _backButton.Pressed += OnBackButtonPressed;
            _saveButton.Pressed += OnSaveButtonPressed;

            LoadPlayerPreview();
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event is InputEventMouseButton mouseButton && mouseButton.ButtonIndex == MouseButton.Left)
            {
                _isDragging = mouseButton.Pressed;
            }

            if (_isDragging && @event is InputEventMouseMotion mouseMotion)
            {
                _skinModelContainer?.RotateY(mouseMotion.Relative.X * _rotateSensitivity);
            }
        }

        /// <summary>
        /// 各部位選択ボタンから呼び出して FileDialog を展開する
        /// </summary>
        public void OpenFileSelectForPart(string partName)
        {
            _selectedPartName = partName;
            if (_fileDialog != null)
            {
                _fileDialog.Title = $"{partName} の画像を選択";
                _fileDialog.PopupCentered();
            }
        }

        private void OnImageFileSelected(string path)
        {
            if (string.IsNullOrEmpty(_selectedPartName)) return;

            var painter = GetNodeOrNull<SkinPainter>("SkinPainter");
            painter?.ApplyCustomImageToPart(_selectedPartName, path);
        }

        private void LoadPlayerPreview()
        {
            var dummyScene = GD.Load<PackedScene>(DummyScenePath);
            if (dummyScene != null)
            {
                var dummyInstance = dummyScene.Instantiate<Node3D>();
                dummyInstance.Call("set_process_movement", false);
                dummyInstance.Position = Vector3.Zero;

                _skinModelContainer.AddChild(dummyInstance);

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

            var painter = GetNodeOrNull<SkinPainter>("SkinPainter");
            if (painter != null)
            {
                painter.SaveAllSkins();
            }
            else
            {
                GD.PrintErr("[SkinEdit] SkinPainter ノードが見つかりません");
            }
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