using Godot;
using SKNewRoles2.Lobby.JOIN;
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
            LobbyRealtime.OnLobbyTableChanged -= onTableChanged;
            LobbyRealtime.OnLobbyTableChanged += onTableChanged;

            if (onTransformReceived != null)
            {
                LobbyRealtime.OnPlayerTransformReceivedAll -= onTransformReceived;
                LobbyRealtime.OnPlayerTransformReceivedAll += onTransformReceived;
            }

            LobbyRealtime.StartListeningLobbyChanges();
        }

        /// <summary>
        /// リアルタイムイベントの受信を停止します
        /// </summary>
        public static void UnregisterListeners(
            Action onTableChanged, 
            Action<string, float, float, float, float, float, float> onTransformReceived)
        {
            LobbyRealtime.OnLobbyTableChanged -= onTableChanged;

            if (onTransformReceived != null)
            {
                LobbyRealtime.OnPlayerTransformReceivedAll -= onTransformReceived;
            }

            LobbyRealtime.StopListeningLobbyChanges();
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

                LobbyRealtime.LobbySendTransformBroadcastAll(
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