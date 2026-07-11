using Godot;
using System;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace SKNewRoles2.SessionManagerSystem
{
    public partial class SessionManager : Node
    {
        // ==========================================
        // 5. Supabase API 通信ヘルパー関数
        // ==========================================
        private void StartUserInfoSync()
        {
            if (IsInsideTree())
            {
                _ = FetchUserInfoAsync();
            }
            else
            {
                CallDeferred(MethodName.TriggerFetchUserInfo);
            }
        }

        private void TriggerFetchUserInfo()
        {
            _ = FetchUserInfoAsync();
        }

        public async Task<bool> FetchUserInfoAsync()
        {
            if (CurrentSession == null || string.IsNullOrEmpty(CurrentSession.AccessToken))
            {
                GD.PrintErr("❌ ユーザー情報を取得できません：セッションがありません。");
                return false;
            }

            var httpRequest = CreateUserInfoHttpRequest();
            string url = $"{SupabaseUrl}/auth/v1/user";
            string[] headers = CreateAuthHeaders();

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>();
            
            Godot.HttpRequest.RequestCompletedEventHandler onCompleted = null;
            onCompleted = (result, responseCode, responseHeaders, body) =>
            {
                httpRequest.RequestCompleted -= onCompleted;
                tcs.SetResult((result, responseCode, body));
            };
            httpRequest.RequestCompleted += onCompleted;

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

            if (code == 401 || code == 400 || code == 403)
            {
                GD.Print($"⚠️ トークン期限切れを検知 (HTTP Code: {code})。リフレッシュを試みます...");
                bool refreshSuccess = await RefreshSessionAsync();
                if (refreshSuccess)
                {
                    return await FetchUserInfoAsync();
                }
                else
                {
                    GD.PrintErr("❌ トークンのリフレッシュに失敗したため、セッションを破棄します。");
                    ClearSession();
                    UserInfoUpdated?.Invoke(); 
                    return false;
                }
            }

            if (code != 200)
            {
                GD.PrintErr($"❌ ユーザー情報取得失敗 (HTTP Code: {code})");
                ClearSession();
                UserInfoUpdated?.Invoke();
                return false;
            }

            return HandleUserInfoResponse(res, code, bodyData);
        }

        public async Task<bool> RefreshSessionAsync()
        {
            if (CurrentSession == null || string.IsNullOrEmpty(CurrentSession.RefreshToken))
            {
                GD.PrintErr("❌ リフレッシュトークンがありません。");
                return false;
            }

            var httpRequest = new HttpRequest();
            AddChild(httpRequest);

            string url = $"{SupabaseUrl}/auth/v1/token?grant_type=refresh_token";
            
            string[] headers = new string[]
            {
                $"apikey: {SupabaseAnonKey}",
                "Content-Type: application/json"
            };

            var payload = new { refresh_token = CurrentSession.RefreshToken };
            string jsonBody = JsonSerializer.Serialize(payload);

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>();
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
                        if (CurrentSession.User != null && newSession.User == null)
                        {
                            newSession.User = CurrentSession.User;
                        }

                        CurrentSession = newSession;
                        SaveSessionToDisk(); 
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

        private HttpRequest CreateUserInfoHttpRequest()
        {
            var httpRequest = new HttpRequest();
            AddChild(httpRequest);
            return httpRequest;
        }

        private string[] CreateAuthHeaders()
        {
            return new string[]
            {
                $"apikey: {SupabaseAnonKey}",
                $"Authorization: Bearer {CurrentSession.AccessToken}",
                "Accept: application/json"
            };
        }

        private bool HandleUserInfoResponse(long res, long code, byte[] bodyData)
        {
            if (res != (long)HttpRequest.Result.Success) return false;
            string jsonText = Encoding.UTF8.GetString(bodyData);
            if (code != 200)
            {
                ClearSession();
                return false;
            }
            return ApplyFreshUserData(jsonText);
        }

        private bool ApplyFreshUserData(string jsonText)
        {
            try
            {
                var freshUser = JsonSerializer.Deserialize<SupabaseUser>(jsonText);
                if (freshUser != null)
                {
                    EnsureUserObjectInitialized();

                    CurrentSession.User.Id = freshUser.Id;
                    CurrentSession.User.Email = freshUser.Email;
                    
                    SaveSessionToDisk();

                    GD.Print($"👤 最新のユーザー情報を同期しました: {freshUser.Email} (ID: {freshUser.Id})");
                    UserInfoUpdated?.Invoke();
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