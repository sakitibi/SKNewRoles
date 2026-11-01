using Godot;
using System.Threading.Tasks;
using SKNewRoles2.Game.Player;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game
{
    public class MainGamePlayerHandler(MainGameScene scene)
    {
        public Node3D MyPlayerInstance { get; private set; }
        public Node HealthComponent { get; private set; }
        private readonly PlayerSpawner _playerSpawner = new(scene);

        public async Task SpawnPlayerAsync()
        {
            (Node3D playerInst, Node healthComp) = await _playerSpawner.SpawnAndSetupMyPlayerAsync(scene);
            
            MyPlayerInstance = playerInst;
            HealthComponent = healthComp;

            if (MyPlayerInstance != null && GodotObject.IsInstanceValid(MyPlayerInstance) && scene.UIController != null)
            {
                scene.UIController.SetPlayerPathToHud(MyPlayerInstance.GetPath());
            }
        }

        public void SetupHungerSignal(PlayerStatusSyncHandler playerStatusSyncHandler)
        {
            if (MyPlayerInstance == null || !GodotObject.IsInstanceValid(MyPlayerInstance)) return;

            Node hungerComp = MyPlayerInstance.GetNodeOrNull<Node>("HungerComponent");
            if (hungerComp != null && GodotObject.IsInstanceValid(hungerComp))
            {
                if (!hungerComp.IsConnected("hunger_changed", Callable.From<int, int>(playerStatusSyncHandler.OnMyPlayerHungerChanged)))
                {
                    hungerComp.Connect("hunger_changed", Callable.From<int, int>(playerStatusSyncHandler.OnMyPlayerHungerChanged));
                    GD.Print("✅ [MainGamePlayerHandler] HungerComponent のシグナル接続に成功しました。");
                }
            }
        }
    }
}