using Godot;
using SKNewRoles2.Game.Player.Handler;

namespace SKNewRoles2.Game.Skill.Witch.Witch
{
    public partial class CombatSyncProxy(PlayerCombatSyncHandler syncHandler) : RefCounted
    {
        public void OnPlayerAttackedRemote(string targetPlayerId, uint damage)
        {
            syncHandler?.OnPlayerAttackedRemote(targetPlayerId, damage);
        }
    }
}