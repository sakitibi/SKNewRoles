using Godot;
using System.Text.Json;
using System.Collections.Generic;
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
            WebSocketPeer client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                return;
            }

            string senderId = GetSenderId();

            RealtimePayload broadcastPayload = new()
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
            Error err = client.SendText(json);
            
            if (err != Error.Ok)
            {
                GD.PrintErr($"❌ [LobbySendTransform 失敗] Error Code: {err} | Topic: {GetTopic()}");
            }
        }

        /// <summary>
        /// ホストから全員に向けてゲーム開始シグナルを送信します。
        /// </summary>
        public static void LobbySendStartGame()
        {
            WebSocketPeer client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                GD.PrintErr($"❌ [ゲーム開始送信失敗] WebSocketがオープン状態ではありません！ ReadyState: {client?.GetReadyState()}");
                return;
            }

            RealtimePayload broadcastPayload = new()
            {
                topic = GetTopic(),
                @event = "broadcast",
                payload = new
                {
                    type = "broadcast",
                    @event = "start_game",
                    payload = new {}
                },
                @ref = null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            Error err = client.SendText(json);
            
            if (err == Error.Ok)
            {
                GD.Print($"📡 [ゲーム開始送信成功] JSONを送信しました -> Topic: {GetTopic()} | JSON: {json}");
            }
            else
            {
                GD.PrintErr($"❌ [ゲーム開始送信エラー] SendText Failed with Error: {err}");
            }
        }

        /// <summary>
        /// 部屋からの退出を他のプレイヤーに通知します。
        /// </summary>
        public static void LobbySendLeave()
        {
            WebSocketPeer client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                GD.PrintErr($"⚠️ [退出通知スキップ] WebSocketがオープンではありません。ReadyState: {client?.GetReadyState()}");
                return;
            }

            string senderId = GetSenderId();

            RealtimePayload broadcastPayload = new()
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
                @ref = null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            Error err = client.SendText(json);

            if (err == Error.Ok)
            {
                GD.Print($"📡 [退出通知送信] 退出ブロードキャストを送信しました -> Topic: {GetTopic()} | PlayerID: {senderId}");
            }
            else
            {
                GD.PrintErr($"❌ [退出通知送信エラー] Error: {err}");
            }
        }

        /// <summary>
        /// 自分のスキン設定を全員に送信します。
        /// </summary>
        public static void LobbySendSkinBroadcast(Dictionary<string, string> skinPresets)
        {
            GD.Print($"LobbySendSkinBroadcast を実行 user_id: {SessionManager.Instance.CurrentSession.User.Id}");
            var client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open)
            {
                GD.PrintErr($"⚠️ [スキン送信スキップ] WebSocketがオープンではありません。ReadyState: {client?.GetReadyState()}");
                return;
            }

            string senderId = GetSenderId();

            RealtimePayload broadcastPayload = new()
            {
                topic = GetTopic(),
                @event = "broadcast",
                payload = new
                {
                    type = "broadcast",
                    @event = "player_skin",
                    payload = new
                    {
                        player_id = senderId,
                        skins = skinPresets
                    }
                },
                @ref = null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            Error err = client.SendText(json);

            if (err == Error.Ok)
            {
                GD.Print($"📡 [スキン送信] スキン情報をブロードキャストしました -> PlayerID: {senderId}");
            }
            else
            {
                GD.PrintErr($"❌ [スキン送信エラー] Error: {err}");
            }
        }
    }
}