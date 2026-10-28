using Godot;
using System;
using System.Collections.Generic;
using System.Text.Json;

namespace SKNewRoles2.Lobby.JOIN.Services.Realtime
{
    public static class RealtimeLobbyReceiver
    {
        /// <summary>
        /// 毎フレーム呼び出し、WebSocketパケットの回収と各イベントの発火を行います。
        /// </summary>
        public static void PollRealtimeEvents()
        {
            if (!RealtimeConnectionService.IsListening || RealtimeConnectionService.RealtimeClient == null) return;

            WebSocketPeer client = RealtimeConnectionService.RealtimeClient;
            client.Poll();
            WebSocketPeer.State state = client.GetReadyState();

            if (state == WebSocketPeer.State.Open)
            {
                while (client.GetAvailablePacketCount() > 0)
                {
                    byte[] rawPacket = client.GetPacket();
                    string message = rawPacket.GetStringFromUtf8();
                    
                    if (string.IsNullOrEmpty(message)) continue;

                    GD.Print($"📥 [Realtime受信 Raw] {message}");

                    try
                    {
                        using JsonDocument doc = JsonDocument.Parse(message);
                        JsonElement root = doc.RootElement;
                        
                        if (root.TryGetProperty("event", out JsonElement evElem))
                        {
                            string ev = evElem.GetString();

                            if (ev == "phx_reply")
                            {
                                ParseReplyMessage(root);
                            }
                            else if (ev == "broadcast")
                            {
                                ParseBroadcastMessage(root);
                                continue;
                            }
                            else if (ev == "system")
                            {
                                ParseSystemMessage(root);
                                continue;
                            }
                            else
                            {
                                GD.Print($"🔍 [Realtime受信その他] event: {ev}");
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
        /// サーバーからの応答（phx_reply）を解析し、エラーや拒否がないか詳細にチェックします
        /// </summary>
        private static void ParseReplyMessage(JsonElement root)
        {
            if (root.TryGetProperty("payload", out JsonElement payload))
            {
                string status = "unknown";
                if (payload.TryGetProperty("status", out JsonElement statusElem))
                {
                    status = statusElem.GetString();
                }

                if (status == "ok")
                {
                    GD.Print("✅ [Realtime Reply] サーバー応答: 成功 (ok)");
                }
                else
                {
                    GD.PrintErr($"❌ [Realtime Reply エラー応答] status: {status} | 全データ: {root.GetRawText()}");
                }
            }
        }

        private static void ParseBroadcastMessage(JsonElement root)
        {
            if (root.TryGetProperty("payload", out JsonElement outerPayload))
            {
                if (outerPayload.TryGetProperty("event", out JsonElement customEventElem))
                {
                    string customEvent = customEventElem.GetString();

                    if (outerPayload.TryGetProperty("payload", out JsonElement innerPayload))
                    {
                        switch (customEvent)
                        {
                            case "transform_all":
                            {
                                string pId = innerPayload.GetProperty("player_id").GetString();
                                float px = (float)innerPayload.GetProperty("px").GetDouble();
                                float py = (float)innerPayload.GetProperty("py").GetDouble();
                                float pz = (float)innerPayload.GetProperty("pz").GetDouble();
                                float rx = (float)innerPayload.GetProperty("rx").GetDouble();
                                float ry = (float)innerPayload.GetProperty("ry").GetDouble();
                                float rz = (float)innerPayload.GetProperty("rz").GetDouble();

                                RealtimeEvents.RaisePlayerTransformReceivedAll(pId, px, py, pz, rx, ry, rz);
                                break;
                            }
                            case "assign_role":
                            {
                                string targetPlayerId = innerPayload.GetProperty("target_player_id").GetString();
                                int role = innerPayload.GetProperty("role").GetInt32();
                                int faction = innerPayload.GetProperty("faction").GetInt32();

                                GD.Print($"👑 役職データ受信成功: Target={targetPlayerId}, Role={role}");
                                RealtimeEvents.RaiseRoleAssignedReceived(targetPlayerId, role, faction);
                                break;
                            }
                            case "start_game":
                            {
                                GD.Print("🎮 [Realtime] ホストからゲーム開始シグナルを受信しました！");
                                RealtimeEvents.RaiseGameStartReceived();
                                break;
                            }
                            case "player_leave":
                            {
                                string pId = innerPayload.GetProperty("player_id").GetString();
                                GD.Print($"👋 [Realtime] プレイヤーの退出を受信しました: {pId}");
                                RealtimeEvents.RaisePlayerLeaveReceived(pId);
                                break;
                            }
                            case "player_skin":
                            {
                                string pId = innerPayload.GetProperty("player_id").GetString();
                                var skinsDict = new Dictionary<string, string>();
                                
                                if (innerPayload.TryGetProperty("skins", out JsonElement skinsElem))
                                {
                                    foreach (var prop in skinsElem.EnumerateObject())
                                    {
                                        skinsDict[prop.Name] = prop.Value.GetString();
                                    }
                                }

                                GD.Print($"🎨 [Realtime] プレイヤーのスキン情報を受信しました: {pId}");
                                RealtimeEvents.RaisePlayerSkinReceived(pId, skinsDict);
                                break;
                            }
                        }
                    }
                }
            }
        }

        private static void ParseSystemMessage(JsonElement root)
        {
            GD.PrintErr($"⚠️ [Realtime System制限通知 全データ] {root.GetRawText()}");
            if (root.TryGetProperty("payload", out JsonElement sysPayload))
            {
                if (sysPayload.TryGetProperty("message", out JsonElement msgElem))
                {
                    GD.PrintErr($"⚠️ [Realtime System制限通知] {msgElem.GetString()}");
                }
            }
        }
    }
}