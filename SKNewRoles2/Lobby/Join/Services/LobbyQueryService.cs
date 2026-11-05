using Godot;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Models;

namespace SKNewRoles2.Lobby.JOIN.Services
{
    public static class LobbyQueryService
    {
        private static GodotObject _cppService;

        private static GodotObject GetCppService()
        {
            if (_cppService == null || !GodotObject.IsInstanceValid(_cppService))
            {
                try
                {
                    _cppService = (GodotObject)ClassDB.Instantiate("LobbyQueryService");
                }
                catch (Exception ex)
                {
                    GD.PrintErr($"❌ [LobbyQueryService] C++ instance creation failed: {ex.Message}");
                }
            }
            return _cppService;
        }

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

            if (res == (long)HttpRequest.Result.Success && code == 200 && bodyData != null)
            {
                string jsonText = Encoding.UTF8.GetString(bodyData);
                var service = GetCppService();

                if (service != null)
                {
                    try
                    {
                        // C++側の高速なJSONパーサーに処理を委譲
                        var godotArray = service.Call("parse_public_lobbies", jsonText).AsGodotArray();
                        foreach (var item in godotArray)
                        {
                            if (item.Obj is Godot.Collections.Dictionary dict)
                            {
                                resultList.Add(new LobbyData
                                {
                                    RoomCode = dict.ContainsKey("room_code") ? dict["room_code"].AsString() : "",
                                    RoomName = dict.ContainsKey("room_name") ? dict["room_name"].AsString() : ""
                                });
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        GD.PrintErr($"⚠️ [LobbyQueryService] C++ parse error (public lobbies): {ex.Message}");
                    }
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
            (long _, long _, byte[] bodyData) = await HttpRequestHelper.SendAsync(url, headers, HttpClient.Method.Get);

            if (bodyData != null && bodyData.Length > 0)
            {
                string rawJson = Encoding.UTF8.GetString(bodyData);
                var service = GetCppService();

                if (service != null)
                {
                    try
                    {
                        string userId = SessionManager.Instance.CurrentSession.User?.Id ?? "";

                        var resultDict = service.Call("parse_lobby_status", rawJson, roomCode, userId).AsGodotDictionary();
                        int statusCode = resultDict.ContainsKey("status_code") ? resultDict["status_code"].AsInt32() : -1;

                        if (statusCode == 0)
                        {
                            SessionManager.Instance.CurrentRoomCode = roomCode;
                            SessionManager.Instance.CurrentRoomName = resultDict.ContainsKey("room_name") ? resultDict["room_name"].AsString() : "";
                            SessionManager.Instance.IsHost = resultDict.ContainsKey("is_host") && resultDict["is_host"].AsBool();
                            if (resultDict.ContainsKey("is_public"))
                            {
                                SessionManager.Instance.IsPublic = resultDict["is_public"].AsBool();
                            }
                            GD.Print("✅ [8] 判定結果: ロビー確認成功！(0を返します)");
                        }
                        else if (statusCode == 1)
                        {
                            GD.Print("⚠️ [8] 判定結果: is_active が false です");
                        }
                        else
                        {
                            GD.PrintErr("⚠️ [8] 判定結果: Supabaseから空の配列 [] が返されました（一致するデータがない、または RLS でブロックされています）");
                        }

                        return statusCode;
                    }
                    catch (Exception ex)
                    {
                        GD.PrintErr($"⚠️ [エラー] C++ parse error (lobby status): {ex.Message}");
                    }
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