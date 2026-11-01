using Godot;
using System.Threading.Tasks;
using SKNewRoles2.Lobby;
using System.Collections.Generic;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game.Player
{
    public class PlayerSpawner(MainGameScene scene)
    {
        private readonly PlayerStatusSyncHandler _playerStatusSyncHandler = new(scene);
        private readonly PlayerSkinSyncHandler _playerSkinSyncHandler = new(scene);
        private readonly MainGameUIHandler _uiHandler = new(scene);

        public Dictionary<string, string> MySkins { get; set; } = [];

        public async Task<(Node3D PlayerInstance, Node HealthComponent)> SpawnAndSetupMyPlayerAsync(Node parent)
        {
            GodotObject cppSpawner = ClassDB.Instantiate("PlayerSpawner").AsGodotObject();
            if (cppSpawner == null)
            {
                GD.PrintErr("[PlayerSpawner] Error: Failed to instantiate C++ PlayerSpawner.");
                return (null, null);
            }

            Node3D playerInstance = cppSpawner.Call("spawn_player", parent).As<Node3D>();
            cppSpawner.Dispose();

            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance))
            {
                GD.PrintErr("[PlayerSpawner] Error: C++ spawn_player returned a null or invalid node.");
                return (null, null);
            }

            MySkins = LobbySkinManager.ApplySavedSkinAndGetPresets(playerInstance);
            
            _ = Task.Run(async () =>
            {
                int retryCount = 0;
                while (retryCount < 5)
                {
                    await _playerSkinSyncHandler.SendMySkinAsync(MySkins);
                    await Task.Delay(1500);
                    retryCount++;
                }
            });

            Node healthComponent = playerInstance.GetNodeOrNull<Node>("HealthComponent");
            Node targetNode = healthComponent ?? playerInstance;

            string[] signalNames = ["HpChanged", "hp_changed", "HealthChanged", "health_changed"];
            foreach (string sig in signalNames)
            {
                if (targetNode.HasSignal(sig))
                {
                    targetNode.Connect(sig, Callable.From<int, int>(_playerStatusSyncHandler.OnMyPlayerHpChanged));
                    break;
                }
            }

            _ = _uiHandler.UpdateHpUIFromPlayer();
            SetPlayerPhysicsEnabled(playerInstance, false);
            
            GD.Print("[PlayerSpawner] My player successfully spawned, skin applied and sent. (Pos: 0, 100, 0)");

            return (playerInstance, healthComponent);
        }

        public static void SetPlayerPhysicsEnabled(Node3D playerInstance, bool enabled)
        {
            if (playerInstance == null || !GodotObject.IsInstanceValid(playerInstance))
            {
                GD.PrintErr("[PlayerSpawner] Warning: playerInstance is invalid or null.");
                return;
            }

            GodotObject cppSpawner = ClassDB.Instantiate("PlayerSpawner").AsGodotObject();
            if (cppSpawner != null)
            {
                cppSpawner.Call("set_player_physics_enabled", playerInstance, enabled);
                cppSpawner.Dispose();
            }
            else
            {
                if (playerInstance.HasMethod("set_movement_enabled"))
                {
                    playerInstance.Call("set_movement_enabled", enabled);
                }
            }
        }
    }
}