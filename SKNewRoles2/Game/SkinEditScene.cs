using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class SkinEditScene : Node3D
    {
        private Button _backButton;
        private Button _saveButton;
        private Node3D _skinModelContainer;

        // 利用可能なプリセットIDのリスト
        private readonly string[] _availablePresets = ["preset_1", "preset_2", "preset_3"];

        // 部位ごとに適用しているプリセットIDを独立管理
        private readonly Dictionary<string, string> _equippedPresets = new()
        {
            { "Head",     "preset_1" },
            { "Body",     "preset_1" },
            { "RightArm", "preset_1" },
            { "LeftArm",  "preset_1" },
            { "RightLeg", "preset_1" },
            { "LeftLeg",  "preset_1" }
        };

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

            _backButton.Pressed += OnBackButtonPressed;
            _saveButton.Pressed += OnSaveButtonPressed;

            const string partUiPath = "CanvasLayer/Control/PartSelectPanel/PartVBox/";
            
            // 各部位ボタンを押すと、その部位のプリセットを順次切り替えて適用
            GetNode<Button>($"{partUiPath}HeadButton").Pressed += () => CyclePartPreset("Head");
            GetNode<Button>($"{partUiPath}BodyButton").Pressed += () => CyclePartPreset("Body");
            GetNode<Button>($"{partUiPath}RightArmButton").Pressed += () => CyclePartPreset("RightArm");
            GetNode<Button>($"{partUiPath}LeftArmButton").Pressed += () => CyclePartPreset("LeftArm");
            GetNode<Button>($"{partUiPath}RightLegButton").Pressed += () => CyclePartPreset("RightLeg");
            GetNode<Button>($"{partUiPath}LeftLegButton").Pressed += () => CyclePartPreset("LeftLeg");

            LoadPlayerPreview();
        }

        /// <summary>
        /// 全部位のプリセットを一括で切り替える（セット選択用）
        /// </summary>
        public void SelectPresetForAll(string presetId)
        {
            foreach (var partName in new List<string>(_equippedPresets.Keys))
            {
                _equippedPresets[partName] = presetId;
            }

            var painter = GetNodeOrNull<SkinPainter>("SkinPainter");
            painter?.ApplyPresetToAllParts(_equippedPresets);
            GD.Print($"[SkinEdit] 全部位のプリセットを一括切り替えました: {presetId}");
        }

        /// <summary>
        /// 指定した部位のプリセットを次のプリセットへ循環切り替え
        /// </summary>
        private void CyclePartPreset(string partName)
        {
            string current = _equippedPresets.GetValueOrDefault(partName, "preset_1");
            int currentIndex = System.Array.IndexOf(_availablePresets, current);
            int nextIndex = (currentIndex + 1) % _availablePresets.Length;
            
            string nextPreset = _availablePresets[nextIndex];
            _equippedPresets[partName] = nextPreset;

            ApplyPartPreset(partName, nextPreset);
        }

        /// <summary>
        /// 単一部位に指定プリセットの画像を適用
        /// </summary>
        private void ApplyPartPreset(string partName, string presetId)
        {
            string resPath = $"res://Resources/Skins/{presetId}/{partName.ToLower()}.png";

            var painter = GetNodeOrNull<SkinPainter>("SkinPainter");
            painter?.ApplyPresetToPart(partName, resPath);
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

        private void LoadPlayerPreview()
        {
            var dummyScene = GD.Load<PackedScene>(DummyScenePath);
            if (dummyScene != null)
            {
                var dummyInstance = dummyScene.Instantiate<Node3D>();
                dummyInstance.Call("set_process_movement", false);
                dummyInstance.Position = Vector3.Zero;

                _skinModelContainer.AddChild(dummyInstance);

                var painter = GetNodeOrNull<SkinPainter>("SkinPainter");
                if (painter != null)
                {
                    painter.Initialize(dummyInstance);
                    // 初期表示時に設定中の部位別プリセットを全適用
                    painter.ApplyPresetToAllParts(_equippedPresets);
                }
            }
            else
            {
                GD.PrintErr($"[SkinEdit] ダミーモデルのロードに失敗しました: {DummyScenePath}");
            }
        }

        private void OnSaveButtonPressed()
        {
            GD.Print("[SkinEdit] スキン設定を確定しました:");
            foreach (var (part, preset) in _equippedPresets)
            {
                GD.Print($"  - {part}: {preset}");
            }
        }

        private void OnBackButtonPressed()
        {
            GetTree().ChangeSceneToFile(LobbySelectScenePath);
        }
    }
}