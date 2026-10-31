using Godot;
using System.Threading.Tasks;
using SKNewRoles2.Game.Player;

namespace SKNewRoles2.Game
{
    public class MainGamePlayerHandler(MainGameScene scene)
    {
        public Node3D MyPlayerInstance { get; private set; }
        public Node HealthComponent { get; private set; }

        public async Task SpawnPlayerAsync(MainGameNetworkHandler networkHandler)
        {
            (Node3D playerInst, Node healthComp) = await PlayerSpawner.SpawnAndSetupMyPlayerAsync(scene, networkHandler);
            
            MyPlayerInstance = playerInst;
            HealthComponent = healthComp;

            if (MyPlayerInstance != null && GodotObject.IsInstanceValid(MyPlayerInstance) && scene.UIController != null)
            {
                scene.UIController.SetPlayerPathToHud(MyPlayerInstance.GetPath());
            }
        }

        public void SetupHungerSignal(MainGameNetworkHandler networkHandler)
        {
            if (MyPlayerInstance == null || !GodotObject.IsInstanceValid(MyPlayerInstance)) return;

            Node hungerComp = MyPlayerInstance.GetNodeOrNull<Node>("HungerComponent");
            if (hungerComp != null && GodotObject.IsInstanceValid(hungerComp))
            {
                if (!hungerComp.IsConnected("hunger_changed", Callable.From<int, int>(networkHandler.OnMyPlayerHungerChanged)))
                {
                    hungerComp.Connect("hunger_changed", Callable.From<int, int>(networkHandler.OnMyPlayerHungerChanged));
                    GD.Print("✅ [MainGamePlayerHandler] HungerComponent のシグナル接続に成功しました。");
                }
            }
        }
    }
}