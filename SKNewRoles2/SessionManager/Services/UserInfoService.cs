using Godot;
using System;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace SKNewRoles2.SessionManagerSystem.Services
{
    public static class UserInfoService
    {
        private static CancellationTokenSource _serviceCts = new();

        /// <summary>
        /// アプリ終了時やセッション終了時にすべての非同期処理を停止します。
        /// </summary>
        public static void CancelAll()
        {
            _serviceCts?.Cancel();
            _serviceCts?.Dispose();
            _serviceCts = new CancellationTokenSource();
        }

        /// <summary>
        /// 安全なタイミングでユーザー情報の同期を開始します。
        /// </summary>
        public static async Task StartUserInfoSync()
        {
            SessionManager manager = SessionManager.Instance;
            if (manager == null) return;

            if (manager.IsInsideTree())
            {
                _ = FetchUserInfoAsync(_serviceCts.Token);
            }
            else
            {
                manager.CallDeferred(nameof(TriggerFetchUserInfo));
            }
        }

        private static void TriggerFetchUserInfo()
        {
            _ = FetchUserInfoAsync(_serviceCts.Token);
        }

        /// <summary>
        /// Supabase API から最新のユーザー情報を非同期取得してセッションに適用します。
        /// </summary>
        public static async Task<bool> FetchUserInfoAsync(CancellationToken cancellationToken = default)
        {
            SessionManager manager = SessionManager.Instance;

            if (manager == null || manager.CurrentSession == null || string.IsNullOrEmpty(manager.CurrentSession.AccessToken))
            {
                return false;
            }

            HttpRequest httpRequest = new();
            manager.AddChild(httpRequest);

            try
            {
                cancellationToken.ThrowIfCancellationRequested();

                string url = $"{SessionManager.SupabaseUrl}/auth/v1/user";
                string[] headers = [
                    $"apikey: {SessionManager.SupabaseAnonKey}",
                    $"Authorization: Bearer {manager.CurrentSession.AccessToken}",
                    "Accept: application/json"
                ];

                TaskCompletionSource<(long result, long responseCode, byte[] body)> tcs = new(TaskCreationOptions.RunContinuationsAsynchronously);

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
                    return false;
                }

                // キャンセル対応付きの非同期待機
                using (cancellationToken.Register(() => tcs.TrySetCanceled()))
                {
                    (long res, long code, byte[] bodyData) = await tcs.Task;

                    if (res != (long)HttpRequest.Result.Success)
                    {
                        return false;
                    }

                    // トークン期限切れの場合
                    if (code == 401 || code == 400 || code == 403)
                    {
                        GD.Print($"⚠️ トークン期限切れを検知 (HTTP Code: {code})。リフレッシュを試みます...");
                        bool refreshSuccess = await AuthTokenService.RefreshSessionAsync();
                        if (refreshSuccess)
                        {
                            return await FetchUserInfoAsync(cancellationToken);
                        }

                        GD.PrintErr("❌ トークンのリフレッシュに失敗したため、セッションを破棄します。");
                        manager.ClearSession();
                        return false;
                    }

                    if (code != 200)
                    {
                        manager.ClearSession();
                        return false;
                    }

                    return await ApplyFreshUserData(bodyData);
                }
            }
            catch (OperationCanceledException)
            {
                // アプリ終了やキャンセル時の正常な中断
                return false;
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ ユーザー情報取得中の予期せぬエラー: {ex.Message}");
                return false;
            }
            finally
            {
                if (GodotObject.IsInstanceValid(httpRequest))
                {
                    httpRequest.QueueFree();
                }
            }
        }

        private static async Task<bool> ApplyFreshUserData(byte[] bodyData)
        {
            SessionManager manager = SessionManager.Instance;
            if (manager == null) return false;

            string jsonText = Encoding.UTF8.GetString(bodyData);

            try
            {
                UserInfo freshUser = JsonSerializer.Deserialize<UserInfo>(jsonText);
                if (freshUser != null)
                {
                    manager.CurrentSession ??= new SessionData();
                    manager.CurrentSession.User ??= new UserInfo();

                    manager.CurrentSession.User.Id = freshUser.Id;
                    manager.CurrentSession.User.Email = freshUser.Email;
                    
                    DiskIO.SaveSessionToDisk(manager.CurrentSession);

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