using System;
using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game
{
    public class GameInitializer
    {
        private readonly ChunkLoader _chunkLoader = new();

        public async Task InitializeAsync(
            MainGameScene scene,
            RealtimeConnection connection,
            GameRoleManager roleManager,
            RemotePlayerManager remotePlayerManager,
            PackedScene opponentScene,
            Node3D chunkManager,
            GameUIController uiController)
        {
            try
            {
                bool isConnected = await connection.EnsureConnectedAsync();
                if (!isConnected)
                {
                    GD.PrintErr("❌ [Realtime] MainGameScene での WebSocket 接続に失敗しました。");
                }

                roleManager.Initialize(scene.GetNode<Node>("RoleManager"));
                remotePlayerManager.Initialize(opponentScene, MainGameScene.GetMyUserId());

                // チャンク読み込み完了の待機
                await _chunkLoader.WaitForInitialChunksLoadedAsync(chunkManager);

                if (SessionManagerSystem.SessionManager.Instance != null && SessionManagerSystem.SessionManager.Instance.IsHost)
                {
                    await roleManager.AssignRolesToAllPlayers(MainGameScene.GetMyUserId());
                }

                bool received = await roleManager.WaitForRoleAssignedAsync(timeoutMs: 10000);
                if (!received)
                {
                    GD.PrintErr("⚠️ 役職受信タイムアウトのため、デフォルト(村人)を適用します");
                    roleManager.ApplyRole(0, 0);
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ [GameInitializer] 初期化待機中にエラーが発生しました: {ex.Message}");
            }
            finally
            {
                uiController?.HideLoadingScene();
            }
        }
    }
}