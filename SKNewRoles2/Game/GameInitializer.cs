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
                if (connection == null) GD.PrintErr("❌ [GameInitializer] 引数 'connection' が null です！");
                if (roleManager == null) GD.PrintErr("❌ [GameInitializer] 引数 'roleManager' が null です！");
                if (remotePlayerManager == null) GD.PrintErr("❌ [GameInitializer] 引数 'remotePlayerManager' が null です！");
                if (scene == null) GD.PrintErr("❌ [GameInitializer] 引数 'scene' が null です！");
                if (chunkManager == null) GD.PrintErr("❌ [GameInitializer] 引数 'chunkManager' が null です！");

                if (connection != null)
                {
                    bool isConnected = await connection.EnsureConnectedAsync();
                    if (!isConnected)
                    {
                        GD.PrintErr("❌ [Realtime] MainGameScene での WebSocket 接続に失敗しました。");
                    }
                }

                Node roleNode = scene?.GetNodeOrNull<Node>("RoleManager");
                if (roleNode == null)
                {
                    GD.PrintErr("⚠️ [GameInitializer] シーン内に 'RoleManager' ノードが見つかりません。");
                }

                roleManager?.Initialize(roleNode, connection);

                string myUserId = MainGameScene.GetMyUserId();
                if (string.IsNullOrEmpty(myUserId))
                {
                    GD.PrintErr("⚠️ [GameInitializer] myUserId が取得できなかったか、空です。");
                }

                remotePlayerManager?.Initialize(opponentScene, myUserId, connection);

                if (chunkManager != null)
                {
                    await ChunkLoader.WaitForInitialChunksLoadedAsync(chunkManager);
                }
                else
                {
                    GD.PrintErr("⚠️ [GameInitializer] chunkManager が null のためチャンク待機をスキップします。");
                }

                // ホストのみが役職の割り当て・送信を実行する
                bool isHost = SessionManager.Instance != null && SessionManager.Instance.IsHost;
                if (isHost)
                {
                    GD.Print("👑 [GameInitializer] ホストとして全員の役職割り当てを開始します。");
                    if (roleManager != null)
                    {
                        await roleManager.AssignRolesToAllPlayers(myUserId);
                    }
                }
                else
                {
                    GD.Print("⏳ [GameInitializer] ゲストとしてホストからの役職受信を待機します。");
                }

                if (roleManager != null)
                {
                    bool received = await roleManager.WaitForRoleAssignedAsync(timeoutMs: 1000000);
                    if (!received)
                    {
                        GD.PrintErr("⚠️ [GameInitializer] 役職受信タイムアウトのため、デフォルト(生徒)を適用します。");
                        roleManager.ApplyRole(0, 0);
                    }
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ [GameInitializer] 初期化待機中にエラーが発生しました: {ex.Message} \nStackTrace: {ex.StackTrace}");
            }
            finally
            {
                uiController?.HideLoadingScene();
            }
        }
    }
}