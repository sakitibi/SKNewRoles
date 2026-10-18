using Godot;
using System;
using System.Text.Json;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.JOIN.Services.Realtime
{
    public static class RealtimeBroadcastService
    {
        private static string GetCurrentTopic()
        {
            return "realtime:public:lobbbies";
        }

        /// <summary>
        /// 毎フレーム呼び出し、WebSocketパケットの回収と各イベントの発火を行います。
        /// </summary>
        public static void PollRealtimeEvents()
        {
            if (!RealtimeConnectionService.IsListening || RealtimeConnectionService.RealtimeClient == null) return;

            var client = RealtimeConnectionService.RealtimeClient;
            client.Poll();
            var state = client.GetReadyState();

            if (state == WebSocketPeer.State.Open)
            {
                while (client.GetAvailablePacketCount() > 0)
                {
                    byte[] rawPacket = client.GetPacket();
                    string message = rawPacket.GetStringFromUtf8();
                    
                    if (string.IsNullOrEmpty(message)) continue;

                    try
                    {
                        using JsonDocument doc = JsonDocument.Parse(message);
                        JsonElement root = doc.RootElement;
                        
                        if (root.TryGetProperty("event", out JsonElement evElem))
                        {
                            string ev = evElem.GetString();

                            if (ev == "broadcast")
                            {
                                if (root.TryGetProperty("payload", out JsonElement outerPayload))
                                {
                                    if (outerPayload.TryGetProperty("event", out JsonElement customEventElem))
                                    {
                                        string customEvent = customEventElem.GetString();

                                        if (outerPayload.TryGetProperty("payload", out JsonElement innerPayload))
                                        {
                                            if (customEvent == "transform_all")
                                            {
                                                string pId = innerPayload.GetProperty("player_id").GetString();
                                                float px = (float)innerPayload.GetProperty("px").GetDouble();
                                                float py = (float)innerPayload.GetProperty("py").GetDouble();
                                                float pz = (float)innerPayload.GetProperty("pz").GetDouble();
                                                float rx = (float)innerPayload.GetProperty("rx").GetDouble();
                                                float ry = (float)innerPayload.GetProperty("ry").GetDouble();
                                                float rz = (float)innerPayload.GetProperty("rz").GetDouble();

                                                RealtimeEvents.RaisePlayerTransformReceivedAll(pId, px, py, pz, rx, ry, rz);
                                            }
                                            else if (customEvent == "assign_role")
                                            {
                                                string targetPlayerId = innerPayload.GetProperty("target_player_id").GetString();
                                                int role = innerPayload.GetProperty("role").GetInt32();
                                                int faction = innerPayload.GetProperty("faction").GetInt32();

                                                GD.Print($"👑 役職データ受信成功: Target={targetPlayerId}, Role={role}");
                                                RealtimeEvents.RaiseRoleAssignedReceived(targetPlayerId, role, faction);
                                            }
                                            else if (customEvent == "start_game")
                                            {
                                                GD.Print("🎮 [Realtime] ホストからゲーム開始シグナルを受信しました！");
                                                RealtimeEvents.RaiseGameStartReceived();
                                            }
                                        }
                                    }
                                }
                                continue;
                            }
                            else if (ev == "system")
                            {
                                if (root.TryGetProperty("payload", out JsonElement sysPayload))
                                {
                                    if (sysPayload.TryGetProperty("message", out JsonElement msgElem))
                                    {
                                        GD.PrintErr($"⚠️ [Realtime System制限通知] {msgElem.GetString()}");
                                    }
                                }
                                continue;
                            }
                            else
                            {
                                // GD.Print($"ℹ️ [その他のイベント] event = {ev} | message = {message}");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        GD.PrintErr($"❌ [Realtime] パース例外: {ex.Message} | 対象メッセージ: {message}");
                    }
                }
            }
            else if (state == WebSocketPeer.State.Closed)
            {
                RealtimeConnectionService.IsListening = false;
                RealtimeConnectionService.IsJoinedChannel = false;
                GD.Print("⚠️ Supabase WebSocket が切断されました。再接続を実行します...");
                RealtimeConnectionService.StartListeningLobbyChanges();
            }
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

            string senderId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(senderId))
            {
                senderId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }

            var broadcastPayload = new
            {
                topic = GetCurrentTopic(),
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
                topic = GetCurrentTopic(),
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
            GD.Print($"📡 [ゲーム開始送信成功] JSONを送信しました -> Topic: {GetCurrentTopic()} | JSON: {json}");
        }
    }
}