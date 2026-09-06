using Godot;

namespace SKNewRoles2.Game
{
    public class PlayerSpawner
    {
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

        public void SetPlayerPhysicsEnabled(Node3D playerInstance, bool enabled)
        {
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance)) return;

            if (playerInstance.HasMethod("set_movement_enabled"))
            {
                playerInstance.Call("set_movement_enabled", enabled);
            }
        }
    }
}