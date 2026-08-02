using Godot;
using System;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace SKNewRoles2.SessionManagerSystem.Services
{
    public static class AuthTokenService
    {
        /// <summary>
        /// リフレッシュトークンを使用して、新しいアクセストークンを取得・更新します。
        /// </summary>
        public static async Task<bool> RefreshSessionAsync()
        {
            var manager = SessionManager.Instance;
            if (manager == null || manager.CurrentSession == null || string.IsNullOrEmpty(manager.CurrentSession.RefreshToken))
            {
                GD.PrintErr("❌ リフレッシュトークンがありません。");
                return false;
            }

            var httpRequest = new HttpRequest();
            manager.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/auth/v1/token?grant_type=refresh_token";
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                "Content-Type: application/json"
            ];

            var payload = new { refresh_token = manager.CurrentSession.RefreshToken };
            string jsonBody = JsonSerializer.Serialize(payload);

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);

            void OnCompleted(long result, long responseCode, string[] responseHeaders, byte[] body)
            {
                httpRequest.RequestCompleted -= OnCompleted;
                tcs.SetResult((result, responseCode, body));
            }

            httpRequest.RequestCompleted += OnCompleted;

            Error err = httpRequest.Request(url, headers, HttpClient.Method.Post, jsonBody);
            if (err != Error.Ok)
            {
                httpRequest.QueueFree();
                return false;
            }

            var (res, code, bodyData) = await tcs.Task;
            httpRequest.QueueFree();

            if (res == (long)HttpRequest.Result.Success && code == 200)
            {
                string responseText = Encoding.UTF8.GetString(bodyData);
                try
                {
                    var newSession = JsonSerializer.Deserialize<SessionData>(responseText);
                    if (newSession != null && !string.IsNullOrEmpty(newSession.AccessToken))
                    {
                        if (manager.CurrentSession.User != null && newSession.User == null)
                        {
                            newSession.User = manager.CurrentSession.User;
                        }

                        manager.CurrentSession = newSession;
                        manager.SaveSessionToDisk(); 
                        GD.Print("✨ トークンのリフレッシュに成功しました！");
                        return true;
                    }
                }
                catch (Exception ex)
                {
                    GD.PrintErr($"❌ リフレッシュJSON解析エラー: {ex.Message}");
                }
            }

            return false;
        }
    }
}