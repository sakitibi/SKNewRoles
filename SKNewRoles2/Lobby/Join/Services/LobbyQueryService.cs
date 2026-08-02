using Godot;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Models;

namespace SKNewRoles2.Lobby.JOIN.Services
{
    public static class LobbyQueryService
    {
        /// <summary>
        /// 公開されているアクティブなロビーの一覧を取得します。
        /// </summary>
        public static async Task<List<LobbyData>> FetchRandomPublicLobbiesAsync()
        {
            List<LobbyData> resultList = [];
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken)) 
                return resultList;

            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?is_active=eq.true&is_public=eq.true&order=created_at.desc&limit=20&select=*";
            
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Accept: application/json"
            ];

            var (res, code, bodyData) = await HttpRequestHelper.SendAsync(url, headers, HttpClient.Method.Get);

            if (res == (long)HttpRequest.Result.Success && code == 200)
            {
                string jsonText = Encoding.UTF8.GetString(bodyData);
                try
                {
                    using JsonDocument doc = JsonDocument.Parse(jsonText);
                    JsonElement root = doc.RootElement;

                    if (root.ValueKind == JsonValueKind.Array)
                    {
                        int arrayLength = root.GetArrayLength();
                        for (int i = 0; i < arrayLength; i++)
                        {
                            JsonElement elem = root[i];
                            resultList.Add(new LobbyData
                            {
                                RoomCode = elem.GetProperty("room_code").GetString() ?? "",
                                RoomName = elem.GetProperty("room_name").GetString() ?? ""
                            });
                        }
                    }
                }
                catch (Exception ex)
                {
                    GD.PrintErr($"⚠️ [Realtime] JSON 解析エラー: {ex.Message}");
                }
            }
            return resultList;
        }

        /// <summary>
        /// 指定された部屋コードのステータスをチェックし、ローカルのセッション情報を更新します。
        /// </summary>
        public static async Task<int> CheckLobbyStatusAsync(string roomCode)
        {
            GD.Print("========================================");
            GD.Print($"🔍 [1] CheckLobbyStatusAsync 開始 (roomCode: '{roomCode}')");

            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken))
            {
                GD.PrintErr("❌ [2] 中止: CurrentSession または AccessToken が null/空 です");
                return -1;
            }

            string escapedCode = Uri.EscapeDataString(roomCode.Trim());
            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?room_code=eq.{escapedCode}&select=*";
            
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Accept: application/json"
            ];

            GD.Print("⏳ [5] Supabaseからのレスポンスを待機中...");
            var (_, _, bodyData) = await HttpRequestHelper.SendAsync(url, headers, HttpClient.Method.Get);

            if (bodyData != null && bodyData.Length > 0)
            {
                string rawJson = Encoding.UTF8.GetString(bodyData);

                try
                {
                    using JsonDocument doc = JsonDocument.Parse(rawJson);
                    JsonElement root = doc.RootElement;

                    if (root.ValueKind == JsonValueKind.Array)
                    {
                        if (root.GetArrayLength() == 0)
                        {
                            GD.PrintErr("⚠️ [8] 判定結果: Supabaseから空の配列 [] が返されました（一致するデータがない、または RLS でブロックされています）");
                            return -1;
                        }

                        JsonElement lobbyElement = root[0];

                        if (lobbyElement.TryGetProperty("is_active", out JsonElement activeElem) && !activeElem.GetBoolean())
                        {
                            GD.Print("⚠️ [8] 判定結果: is_active が false です");
                            return 1; 
                        }

                        SessionManager.Instance.CurrentRoomCode = roomCode;
                        SessionManager.Instance.CurrentRoomName = lobbyElement.GetProperty("room_name").GetString();
                        SessionManager.Instance.IsHost = (
                            lobbyElement.GetProperty("host_id").GetString() ==
                            SessionManager.Instance.CurrentSession.User.Id
                        );

                        if (lobbyElement.TryGetProperty("is_public", out JsonElement publicElem))
                        {
                            SessionManager.Instance.IsPublic = publicElem.GetBoolean();
                        }

                        GD.Print("✅ [8] 判定結果: ロビー確認成功！(0を返します)");
                        return 0;
                    }
                }
                catch (Exception ex)
                {
                    GD.PrintErr($"⚠️ [エラー] JSON解析失敗: {ex.Message}");
                }
            }
            else
            {
                GD.PrintErr("⚠️ [7] レスポンスの Body が空です");
            }

            return -1;
        }

        /// <summary>
        /// ロビーへ参加可能かどうか検証します。
        /// </summary>
        public static async Task<bool> JoinLobbyAsync(string roomCode)
        {
            int status = await CheckLobbyStatusAsync(roomCode);
            return status == 0;
        }
    }
}