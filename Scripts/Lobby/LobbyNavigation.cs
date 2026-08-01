using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN;

namespace SKNewRoles2.Lobby
{
    /// <summary>
    /// ロビーからの退出やゲーム画面への遷移を担当するクラス
    /// </summary>
    public static class LobbyNavigation
    {
        private const string DefaultLobbySelectScene = "res://Scenes/Lobby_select.tscn";
        private const string DefaultMainGameScene = "res://Scenes/Gamemaps/MainGameScene.tscn";

        /// <summary>
        /// ホストの場合はロビー解散、ゲストの場合は切断を行ってロビー選択画面に移動します
        /// </summary>
        public static async Task LeaveLobbyAsync(SceneTree tree, Button leaveButton, Action cleanupAction)
        {
            if (leaveButton != null && GodotObject.IsInstanceValid(leaveButton))
            {
                leaveButton.Disabled = true;
            }

            if (SessionManager.Instance.IsHost)
            {
                GD.Print("👑 ホストが退出したため、ロビーを解散します...");
                await LobbySettings.CloseLobbyAsync(SessionManager.Instance.CurrentRoomCode);
            }

            LeaveLobbyCleanup(tree, cleanupAction);
        }

        /// <summary>
        /// セッションの情報をリセットしてシーンを読み直します
        /// </summary>
        public static void LeaveLobbyCleanup(SceneTree tree, Action cleanupAction, string targetScene = DefaultLobbySelectScene)
        {
            cleanupAction?.Invoke();

            SessionManager.Instance.CurrentRoomCode = "";
            SessionManager.Instance.CurrentRoomName = "";
            SessionManager.Instance.IsHost = false;

            tree?.ChangeSceneToFile(targetScene);
        }

        /// <summary>
        /// 参加者リストのIDを集計し、ゲームメインステージへ遷移します
        /// </summary>
        public static void TransitionToGameStage(SceneTree tree, IEnumerable<string> remotePlayerIds, Action cleanupAction, string gameScenePath = DefaultMainGameScene)
        {
            if (tree == null) return;

            SessionManager.Instance.CurrentRoomPlayerIds.Clear();

            // 自身の ID を追加
            string myId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myId))
            {
                myId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }
            SessionManager.Instance.CurrentRoomPlayerIds.Add(myId);

            // リモートプレイヤーの ID を追加
            if (remotePlayerIds != null)
            {
                foreach (string remoteId in remotePlayerIds)
                {
                    if (!SessionManager.Instance.CurrentRoomPlayerIds.Contains(remoteId))
                    {
                        SessionManager.Instance.CurrentRoomPlayerIds.Add(remoteId);
                    }
                }
            }

            GD.Print($"🎮 メインステージへ安全に遷移します。参加者数: {SessionManager.Instance.CurrentRoomPlayerIds.Count} 人");

            cleanupAction?.Invoke();
            tree.ChangeSceneToFile(gameScenePath);
        }
    }
}