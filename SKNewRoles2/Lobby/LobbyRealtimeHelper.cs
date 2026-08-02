using Godot;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;
using System;

namespace SKNewRoles2.Lobby
{
    /// <summary>
    /// リアルタイム通信のイベント管理やブロードキャスト処理を担当するクラス
    /// </summary>
    public static class LobbyRealtimeHelper
    {
        /// <summary>
        /// リアルタイムイベントの受信を開始します
        /// </summary>
        public static void RegisterListeners(
            Action onTableChanged, 
            Action<string, float, float, float, float, float, float> onTransformReceived)
        {
            RealtimeEvents.OnLobbyTableChanged -= onTableChanged;
            RealtimeEvents.OnLobbyTableChanged += onTableChanged;

            if (onTransformReceived != null)
            {
                RealtimeEvents.OnPlayerTransformReceivedAll -= onTransformReceived;
                RealtimeEvents.OnPlayerTransformReceivedAll += onTransformReceived;
            }

            RealtimeConnectionService.StartListeningLobbyChanges();
        }

        /// <summary>
        /// リアルタイムイベントの受信を停止します
        /// </summary>
        public static void UnregisterListeners(
            Action onTableChanged, 
            Action<string, float, float, float, float, float, float> onTransformReceived)
        {
            RealtimeEvents.OnLobbyTableChanged -= onTableChanged;

            if (onTransformReceived != null)
            {
                RealtimeEvents.OnPlayerTransformReceivedAll -= onTransformReceived;
            }

            RealtimeConnectionService.StopListeningLobbyChanges();
        }

        /// <summary>
        /// 指定した間隔ごとにプレイヤーの位置・回転情報を送信します
        /// </summary>
        public static void UpdatePlayerTransformBroadcast(Node3D targetNode, ref float broadcastTimer, float delta, float interval = 0.05f)
        {
            if (targetNode == null || !GodotObject.IsInstanceValid(targetNode)) return;

            broadcastTimer += delta;
            if (broadcastTimer >= interval)
            {
                broadcastTimer = 0.0f;

                RealtimeBroadcastService.LobbySendTransformBroadcastAll(
                    targetNode.Position.X,
                    targetNode.Position.Y,
                    targetNode.Position.Z,
                    targetNode.Rotation.X,
                    targetNode.Rotation.Y,
                    targetNode.Rotation.Z
                );
            }
        }
    }
}