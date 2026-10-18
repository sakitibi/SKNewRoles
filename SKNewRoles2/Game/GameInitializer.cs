using System;
using System.Threading.Tasks;
using Godot;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Player;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Game
{
    public class GameInitializer
    {
        public static async Task InitializeAsync(
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

                roleManager.Initialize(scene.GetNodeOrNull<Node>("RoleManager"), connection);
                remotePlayerManager.Initialize(opponentScene, MainGameScene.GetMyUserId(), connection);

                await ChunkLoader.WaitForInitialChunksLoadedAsync(chunkManager);

                string myUserId = MainGameScene.GetMyUserId();

                // ホストのみが役職の割り当て・送信を実行する
                bool isHost = SessionManager.Instance != null && SessionManager.Instance.IsHost;
                if (isHost)
                {
                    GD.Print("👑 [GameInitializer] ホストとして全員の役職割り当てを開始します。");
                    await roleManager.AssignRolesToAllPlayers(myUserId);
                }
                else
                {
                    GD.Print("⏳ [GameInitializer] ゲストとしてホストからの役職受信を待機します。");
                }

                bool received = await roleManager.WaitForRoleAssignedAsync(timeoutMs: 1000000);
                if (!received)
                {
                    GD.PrintErr("⚠️ [GameInitializer] 役職受信タイムアウトのため、デフォルト(生徒)を適用します。");
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