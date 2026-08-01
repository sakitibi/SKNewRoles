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

            // 🔍 【デバッグ出力】送信ヘッダーとボディの確認
            GD.Print("\n--- 🛰️ Supabase [POST: ロビー作成] リクエスト送信 ---");
            GD.Print($"[URL]: {url}");
            GD.Print("[Headers]:\n" + string.Join("\n", headers));
            GD.Print($"[Body]: {jsonBody}\n---------------------------------------------\n");

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

            GD.Print("\n--- 📥 Supabase [POST: ロビー作成] レスポンス受信 ---");
            GD.Print($"[HTTP Code]: {code}");
            GD.Print($"[Internal Result]: {res}");
            GD.Print($"[Response Body]: {resBody}\n---------------------------------------------\n");

            return (res == (long)HttpRequest.Result.Success && (code == 200 || code == 201));
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

            // 🔥 【超重要】is_active だけでなく、自分の host_id も明示的に含めて送信する
            var payload = new { 
                is_active = false,
                host_id = SessionManager.Instance.CurrentSession.User.Id // 👈 これを追加！
            };
            string jsonBody = JsonSerializer.Serialize(payload);

            GD.Print("\n--- 🛰️ Supabase [PATCH: ロビー非アクティブ化] リクエスト送信 ---");
            GD.Print($"[URL]: {url}");
            GD.Print("[Headers]:\n" + string.Join("\n", headers));
            GD.Print($"[Body]: {jsonBody}\n---------------------------------------------\n");

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
            GD.Print("\n--- 📥 Supabase [PATCH: ロビー非アクティブ化] レスポンス受信 ---");
            GD.Print($"[HTTP Code]: {code}");
            GD.Print($"[Response Body]: {resBody}\n---------------------------------------------\n");

            if (res == (long)HttpRequest.Result.Success && (code == 200 || code == 204))
            {
                GD.Print("✅ Supabase上のロビーの非アクティブ化(is_active=false)に成功しました！");
                return true;
            }
            return false;
        }
    }
}