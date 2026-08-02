using Godot;
using System;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace SKNewRoles2.SessionManagerSystem.Services
{
    public static class UserInfoService
    {
        /// <summary>
        /// 安全なタイミングでユーザー情報の同期を開始します。
        /// </summary>
        public static void StartUserInfoSync()
        {
            var manager = SessionManager.Instance;
            if (manager == null) return;

            if (manager.IsInsideTree())
            {
                _ = FetchUserInfoAsync();
            }
            else
            {
                manager.CallDeferred(nameof(TriggerFetchUserInfo));
            }
        }

        private static void TriggerFetchUserInfo()
        {
            _ = FetchUserInfoAsync();
        }

        /// <summary>
        /// Supabase API から最新のユーザー情報を非同期取得してセッションに適用します。
        /// </summary>
        public static async Task<bool> FetchUserInfoAsync()
        {
            var manager = SessionManager.Instance;

            if (manager == null || manager.CurrentSession == null || string.IsNullOrEmpty(manager.CurrentSession.AccessToken))
            {
                GD.PrintErr("❌ ユーザー情報を取得できません：セッションがありません。");
                return false;
            }

            var httpRequest = new HttpRequest();
            manager.AddChild(httpRequest);

            string url = $"{SessionManager.SupabaseUrl}/auth/v1/user";
            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {manager.CurrentSession.AccessToken}",
                "Accept: application/json"
            ];

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);

            void OnCompleted(long result, long responseCode, string[] responseHeaders, byte[] body)
            {
                httpRequest.RequestCompleted -= OnCompleted;
                tcs.SetResult((result, responseCode, body));
            }

            httpRequest.RequestCompleted += OnCompleted;

            Error err = httpRequest.Request(url, headers, HttpClient.Method.Get, "");
            if (err != Error.Ok)
            {
                GD.PrintErr("❌ ユーザー情報リクエストの送信に失敗しました。");
                httpRequest.QueueFree();
                return false;
            }

            var (res, code, bodyData) = await tcs.Task;
            httpRequest.QueueFree();

            if (res != (long)HttpRequest.Result.Success)
            {
                GD.PrintErr($"❌ ユーザー情報取得：ネットワークエラー (Result: {res})");
                return false;
            }

            // トークン期限切れの場合
            if (code == 401 || code == 400 || code == 403)
            {
                GD.Print($"⚠️ トークン期限切れを検知 (HTTP Code: {code})。リフレッシュを試みます...");
                bool refreshSuccess = await AuthTokenService.RefreshSessionAsync();
                if (refreshSuccess)
                {
                    return await FetchUserInfoAsync();
                }

                GD.PrintErr("❌ トークンのリフレッシュに失敗したため、セッションを破棄します。");
                manager.ClearSession();
                return false;
            }

            if (code != 200)
            {
                GD.PrintErr($"❌ ユーザー情報取得失敗 (HTTP Code: {code})");
                manager.ClearSession();
                return false;
            }

            return ApplyFreshUserData(bodyData);
        }

        private static bool ApplyFreshUserData(byte[] bodyData)
        {
            var manager = SessionManager.Instance;
            if (manager == null) return false;

            string jsonText = Encoding.UTF8.GetString(bodyData);

            try
            {
                var freshUser = JsonSerializer.Deserialize<UserInfo>(jsonText);
                if (freshUser != null)
                {
                    manager.CurrentSession ??= new SessionData();
                    manager.CurrentSession.User ??= new UserInfo();

                    manager.CurrentSession.User.Id = freshUser.Id;
                    manager.CurrentSession.User.Email = freshUser.Email;
                    
                    manager.SaveSessionToDisk();

                    GD.Print($"👤 最新のユーザー情報を同期しました: {freshUser.Email} (ID: {freshUser.Id})");
                    return true;
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ ユーザー情報のJSON解析エラー: {ex.Message}");
            }

            return false;
        }
    }
}