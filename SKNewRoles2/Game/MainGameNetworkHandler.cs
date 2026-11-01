using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game
{
    public class MainGameNetworkHandler(MainGameScene scene)
    {
        public PlayerCombatSyncHandler CombatSync { get; } = new(scene);
        public PlayerSkinSyncHandler SkinSync { get; } = new(scene);

        public void RegisterEvents(RealtimeConnection connection)
        {
            if (connection == null) return;
            connection.OnAttackReceived += CombatSync.OnRemoteAttackReceived;
            connection.OnSkinReceived += SkinSync.OnRemoteSkinReceived;
        }

        public void UnregisterEvents(RealtimeConnection connection)
        {
            if (connection == null) return;
            connection.OnAttackReceived -= CombatSync.OnRemoteAttackReceived;
            connection.OnSkinReceived -= SkinSync.OnRemoteSkinReceived;
        }
    }
}