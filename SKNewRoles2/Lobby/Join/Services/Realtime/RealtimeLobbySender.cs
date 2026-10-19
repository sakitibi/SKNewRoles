using Godot;
using System.Text.Json;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Lobby.JOIN.Services.Realtime
{
    public static class RealtimeLobbySender
    {
        private static string GetTopic() => RealtimeTopicProvider.GetCurrentTopic();

        private static string GetSenderId()
        {
            string senderId = SessionManager.Instance?.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(senderId))
            {
                senderId = $"Guest_{SessionManager.Instance?.CurrentRoomCode}";
            }
            return senderId;
        }

        /// <summary>
        /// 自分の最新の3D座標を送信します。
        /// </summary>
        public static void LobbySendTransformBroadcastAll(float px, float py, float pz, float rx, float ry, float rz)
        {
            var client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                return;
            }

            string senderId = GetSenderId();

            var broadcastPayload = new
            {
                topic = GetTopic(),
                @event = "broadcast",
                payload = new
                {
                    type = "broadcast",
                    @event = "transform_all",
                    payload = new
                    {
                        player_id = senderId, 
                        px, py, pz,
                        rx, ry, rz
                    }
                },
                @ref = (string)null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            client.SendText(json);
        }

        /// <summary>
        /// ホストから全員に向けてゲーム開始シグナルを送信します。
        /// </summary>
        public static void LobbySendStartGame()
        {
            var client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                GD.PrintErr("❌ [ゲーム開始送信失敗] WebSocketがオープン状態ではありません！");
                return;
            }

            var broadcastPayload = new
            {
                topic = GetTopic(),
                @event = "broadcast",
                payload = new
                {
                    type = "broadcast",
                    @event = "start_game",
                    payload = new {}
                },
                @ref = (string)null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            client.SendText(json);
            GD.Print($"📡 [ゲーム開始送信成功] JSONを送信しました -> Topic: {GetTopic()} | JSON: {json}");
        }

        /// <summary>
        /// 部屋からの退出を他のプレイヤーに通知します。
        /// </summary>
        public static void LobbySendLeave()
        {
            var client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                return;
            }

            string senderId = GetSenderId();

            var broadcastPayload = new
            {
                topic = GetTopic(),
                @event = "broadcast",
                payload = new
                {
                    type = "broadcast",
                    @event = "player_leave",
                    payload = new
                    {
                        player_id = senderId
                    }
                },
                @ref = (string)null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            client.SendText(json);
            GD.Print($"📡 [退出通知送信] 退出ブロードキャストを送信しました -> Topic: {GetTopic()} | PlayerID: {senderId}");
        }
    }
}