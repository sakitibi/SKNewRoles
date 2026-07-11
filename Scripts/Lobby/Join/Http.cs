using Godot;
using System.Collections.Generic;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.JOIN
{
    public class LobbyData
    {
        public string RoomCode { get; set; } = "";
        public string RoomName { get; set; } = "";
    }

    public partial class Http
    {
        
        /// <summary>
        /// 公開されているアクティブなロビーの一覧を最大20件、作成日降順でランダム（最新順）に取得します。
        /// </summary>
        public static async Task<List<LobbyData>> FetchRandomPublicLobbiesAsync()
        {
            List<LobbyData> resultList = [];
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken)) return resultList;

            var httpRequest = new HttpRequest();
            SessionManager.Instance.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?is_active=eq.true&is_public=eq.true&order=created_at.desc&limit=20&select=*";
            
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Accept: application/json"
            ];

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);
            HttpRequest.RequestCompletedEventHandler onCompleted = null;
            onCompleted = (result, responseCode, responseHeaders, body) =>
            {
                httpRequest.RequestCompleted -= onCompleted;
                tcs.SetResult((result, responseCode, body));
            };
            httpRequest.RequestCompleted += onCompleted;

            Error err = httpRequest.Request(url, headers, HttpClient.Method.Get, "");
            if (err != Error.Ok)
            {
                httpRequest.QueueFree();
                return resultList;
            }

            var (res, code, bodyData) = await tcs.Task;
            httpRequest.QueueFree();

            if (res == (long)HttpRequest.Result.Success && code == 200)
            {
                string jsonText = Encoding.UTF8.GetString(bodyData);
                try
                {
                    using (JsonDocument doc = JsonDocument.Parse(jsonText))
                    {
                        JsonElement root = doc.RootElement;
                        if (root.ValueKind == JsonValueKind.Array)
                        {
                            foreach (JsonElement elem in root.EnumerateArray())
                            {
                                resultList.Add(new LobbyData
                                {
                                    RoomCode = elem.GetProperty("room_code").GetString(),
                                    RoomName = elem.GetProperty("room_name").GetString()
                                });
                            }
                        }
                    }
                }
                catch { }
            }
            return resultList;
        }

        /// <summary>
        /// 指定された部屋コードのステータスをチェックし、ローカルのセッション情報を更新します。
        /// 戻り値: 0 = アクティブなロビー、1 = 終了（非アクティブ）したロビー、-1 = エラーまたは削除済み
        /// </summary>
        public static async Task<int> CheckLobbyStatusAsync(string roomCode)
        {
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken)) return -1;

            var httpRequest = new HttpRequest();
            SessionManager.Instance.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?room_code=eq.{roomCode}&select=*";
            
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Accept: application/json"
            ];

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);
            HttpRequest.RequestCompletedEventHandler onCompleted = null;
            onCompleted = (result, responseCode, responseHeaders, body) =>
            {
                httpRequest.RequestCompleted -= onCompleted;
                tcs.SetResult((result, responseCode, body));
            };
            httpRequest.RequestCompleted += onCompleted;

            Error err = httpRequest.Request(url, headers, HttpClient.Method.Get, "");
            if (err != Error.Ok)
            {
                httpRequest.QueueFree();
                return -1;
            }

            var (res, code, bodyData) = await tcs.Task;
            httpRequest.QueueFree();

            if (res == (long)HttpRequest.Result.Success && code == 200)
            {
                string jsonText = Encoding.UTF8.GetString(bodyData);
                try
                {
                    using (JsonDocument doc = JsonDocument.Parse(jsonText))
                    {
                        JsonElement root = doc.RootElement;
                        if (root.ValueKind == JsonValueKind.Array && root.GetArrayLength() == 0) return -1;

                        JsonElement lobbyElement = root[0];

                        if (lobbyElement.TryGetProperty("is_active", out JsonElement activeElem) && !activeElem.GetBoolean())
                        {
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

                        return 0;
                    }
                }
                catch
                {
                    return -1;
                }
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

        /// <summary>
        /// サーバー側のロビーの公開/非公開（is_public）設定を更新します。
        /// </summary>
        public static async Task<bool> UpdateLobbyPrivacyAsync(string roomCode, bool isPublic)
        {
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken)) return false;

            var httpRequest = new HttpRequest();
            SessionManager.Instance.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?room_code=eq.{roomCode}";

            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Content-Type: application/json",
                "Prefer: return=representation"
            ];

            var payload = new { is_public = isPublic };
            string jsonBody = JsonSerializer.Serialize(payload);

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);
            HttpRequest.RequestCompletedEventHandler onCompleted = null;
            onCompleted = (result, responseCode, responseHeaders, body) =>
            {
                httpRequest.RequestCompleted -= onCompleted;
                tcs.SetResult((result, responseCode, body));
            };
            httpRequest.RequestCompleted += onCompleted;

            Error err = httpRequest.Request(url, headers, HttpClient.Method.Patch, jsonBody);
            if (err != Error.Ok)
            {
                httpRequest.QueueFree();
                return false;
            }

            var (res, code, _) = await tcs.Task;
            httpRequest.QueueFree();

            if (res == (long)HttpRequest.Result.Success && (code == 200 || code == 204))
            {
                SessionManager.Instance.IsPublic = isPublic; 
                return true;
            }
            return false;
        }
    }
}