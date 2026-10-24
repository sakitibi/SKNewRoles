using Godot;

namespace SKNewRoles2.Game.Player
{
    public class PlayerSpawner
    {
        private static readonly SkinEditScene _skin_edit_scene = new();
        private readonly PackedScene _playerScene = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");

        public (Node3D PlayerInstance, Node HealthComponent) SpawnMyPlayer(Node parent, MainGameSceneNetwork networkHandler)
        {
            if (_playerScene == null)
            {
                GD.PrintErr("❌ [PlayerSpawner] Player.tscn のロードに失敗しています。");
                return (null, null);
            }

            var playerInstance = _playerScene.Instantiate<Node3D>();
            playerInstance.Name = "MyPlayer";
            parent.AddChild(playerInstance);

            ApplySavedSkinToPlayer(playerInstance);

            Vector3 spawnPos = new(0, 100, 0);
            playerInstance.GlobalPosition = spawnPos;

            SetPlayerPhysicsEnabled(playerInstance, false);

            var healthComponent = playerInstance.GetNodeOrNull<Node>("HealthComponent");
            Node targetNode = healthComponent ?? playerInstance;

            string[] signalNames = ["HpChanged", "hp_changed", "HealthChanged", "health_changed"];
            foreach (var sig in signalNames)
            {
                if (targetNode.HasSignal(sig))
                {
                    targetNode.Connect(sig, Callable.From<int, int>(networkHandler.OnMyPlayerHpChanged));
                    break;
                }
            }

            networkHandler?.UpdateHpUIFromPlayer();
            GD.Print($"👤 [PlayerSpawner] 自プレイヤーを生成しました。(Pos: {spawnPos})");

            return (playerInstance, healthComponent);
        }

        /// <summary>
        /// プレイヤーインスタンスに保存されたカスタムスキンを適用します。
        /// </summary>
        private static void ApplySavedSkinToPlayer(Node3D playerInstance)
        {
            var config = new ConfigFile();
            Error err = config.Load("user://player_skin.cfg");

            if (err == Error.Ok)
            {
                foreach (string partName in _skin_edit_scene.equippedPresets.Keys)
                {
                    if (config.HasSectionKey("PlayerSkin", partName))
                    {
                        _skin_edit_scene.equippedPresets[partName] = (string)config.GetValue("PlayerSkin", partName);
                    }
                }
            }
            else
            {
                GD.Print("[PlayerSpawner] 保存されたスキン設定が見つからないため、デフォルトを使用します。");
            }

            var painter = playerInstance.GetNodeOrNull<SkinPainter>("SkinPainter");
            if (painter == null)
            {
                painter = new SkinPainter();
                playerInstance.AddChild(painter);
                painter.Name = "SkinPainter";
            }

            painter.Initialize(playerInstance);
            painter.ApplyPresetToAllParts(_skin_edit_scene.equippedPresets);
            GD.Print("[PlayerSpawner] プレイヤーに保存されたスキンを適用しました！");
        }

        public static void SetPlayerPhysicsEnabled(Node3D playerInstance, bool enabled)
        {
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance)) return;

            if (playerInstance.HasMethod("set_movement_enabled"))
            {
                playerInstance.Call("set_movement_enabled", enabled);
            }
        }
    }
}