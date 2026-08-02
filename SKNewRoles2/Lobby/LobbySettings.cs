using Godot;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby
{
    public partial class LobbySettings
    {
        /// <summary>
        /// [MOD API] 公開・非公開フラグを指定してSupabase上にロビーを作成します。
        /// </summary>
        public static async Task<bool> CreateLobbyAsync(string roomCode, string roomName, bool isPublic)
        {
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken))
            {
                GD.PrintErr("❌ CreateLobbyAsync: トークンが無効なためリクエストを中断しました。");
                return false;
            }

            var httpRequest = new HttpRequest();
            SessionManager.Instance.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies";
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Content-Type: application/json",
                "Prefer: return=representation"
            ];

            var payload = new { 
                room_code = roomCode, 
                room_name = roomName, 
                host_id = SessionManager.Instance.CurrentSession.User.Id, 
                is_active = true,
                is_public = isPublic
            };
            string jsonBody = JsonSerializer.Serialize(payload);

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);
            HttpRequest.RequestCompletedEventHandler onCompleted = null;
            onCompleted = (result, responseCode, responseHeaders, body) =>
            {
                httpRequest.RequestCompleted -= onCompleted;
                tcs.SetResult((result, responseCode, body));
            };
            httpRequest.RequestCompleted += onCompleted;

            Error err = httpRequest.Request(url, headers, HttpClient.Method.Post, jsonBody);
            if (err != Error.Ok)
            {
                GD.PrintErr($"❌ CreateLobbyAsync: リクエスト送信に失敗。Error: {err}");
                httpRequest.QueueFree();
                return false;
            }

            var (res, code, bodyData) = await tcs.Task;
            httpRequest.QueueFree();

            string resBody = bodyData != null ? Encoding.UTF8.GetString(bodyData) : "空データ";

            return res == (long)HttpRequest.Result.Success && (code == 200 || code == 201);
        }

        /// <summary>
        /// ロビーをクローズ（解散）します。
        /// </summary>
        public static async Task<bool> CloseLobbyAsync(string roomCode)
        {
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken))
            {
                GD.PrintErr("❌ CloseLobbyAsync: トークンが無効なためリクエストを中断しました。");
                return false;
            }

            var httpRequest = new HttpRequest();
            SessionManager.Instance.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?room_code=eq.{roomCode}";
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Content-Type: application/json",
                "Prefer: return=representation"
            ];

            var payload = new { 
                is_active = false,
                host_id = SessionManager.Instance.CurrentSession.User.Id
            };
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
                GD.PrintErr($"❌ CloseLobbyAsync: リクエスト送信に失敗。Error: {err}");
                httpRequest.QueueFree();
                return false;
            }

            var (res, code, bodyData) = await tcs.Task;
            httpRequest.QueueFree();

            string resBody = bodyData != null ? Encoding.UTF8.GetString(bodyData) : "空データ";

            if (res == (long)HttpRequest.Result.Success && (code == 200 || code == 204))
            {
                GD.Print("✅ Supabase上のロビーの非アクティブ化(is_active=false)に成功しました！");
                return true;
            }
            return false;
        }
    }
}