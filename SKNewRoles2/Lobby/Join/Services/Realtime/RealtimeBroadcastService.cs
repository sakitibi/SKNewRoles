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
            string roomCode = SessionManager.Instance.CurrentRoomCode;
            return string.IsNullOrEmpty(roomCode) ? "room:global_lobby" : $"room:{roomCode}";
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

                            // Broadcast パケットの識別処理
                            if (ev == "broadcast")
                            {
                                JsonElement payload = root.GetProperty("payload");
                                if (payload.TryGetProperty("type", out JsonElement typeElem))
                                {
                                    string type = typeElem.GetString();

                                    // 位置・回転データの受信
                                    if (type == "transform_all")
                                    {
                                        string pId = payload.GetProperty("player_id").GetString();
                                        
                                        float px = (float)payload.GetProperty("px").GetDouble();
                                        float py = (float)payload.GetProperty("py").GetDouble();
                                        float pz = (float)payload.GetProperty("pz").GetDouble();
                                        float rx = (float)payload.GetProperty("rx").GetDouble();
                                        float ry = (float)payload.GetProperty("ry").GetDouble();
                                        float rz = (float)payload.GetProperty("rz").GetDouble();
                                        
                                        RealtimeEvents.RaisePlayerTransformReceivedAll(pId, px, py, pz, rx, ry, rz);
                                    }
                                    // 役職割当データの受信
                                    else if (type == "assign_role")
                                    {
                                        string targetPlayerId = payload.GetProperty("target_player_id").GetString();
                                        int role = payload.GetProperty("role").GetInt32();
                                        int faction = payload.GetProperty("faction").GetInt32();

                                        RealtimeEvents.RaiseRoleAssignedReceived(targetPlayerId, role, faction);
                                    }
                                    // ゲーム開始シグナルの受信
                                    else if (type == "start_game")
                                    {
                                        GD.Print("🎮 [Realtime] ホストからゲーム開始シグナルを受信しました！");
                                        RealtimeEvents.RaiseGameStartReceived();
                                    }
                                }
                                continue;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        GD.PrintErr($"❌ [Realtime] パース/イベント処理エラー: {ex.Message} | メッセージ: {message}");
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
        /// 自分の最新のフル3D座標を送信します。
        /// </summary>
        public static void LobbySendTransformBroadcastAll(float px, float py, float pz, float rx, float ry, float rz)
        {
            var client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open) return;

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
                    type = "transform_all",
                    player_id = senderId, 
                    px,
                    py,
                    pz,
                    rx,
                    ry,
                    rz
                },
                @ref = (string)null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            client.SendText(json);
        }

        /// <summary>
        /// ホストから全員に向けてゲーム開始のシグナルをBroadcast送信します。
        /// </summary>
        public static void LobbySendStartGame()
        {
            var client = RealtimeConnectionService.RealtimeClient;
            if (client == null || client.GetReadyState() != WebSocketPeer.State.Open) return;

            var broadcastPayload = new
            {
                topic = GetCurrentTopic(),
                @event = "broadcast",
                payload = new
                {
                    type = "start_game"
                },
                @ref = (string)null
            };

            string json = JsonSerializer.Serialize(broadcastPayload);
            client.SendText(json);
            GD.Print($"📡 [Realtime] ゲーム開始のBroadcastを送信しました (Topic: {GetCurrentTopic()})。");
        }
    }
}