using Godot;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.JOIN.Services
{
    public static class HttpRequestHelper
    {
        /// <summary>
        /// GodotのHttpRequestを非同期Taskとして実行し、レスポンスを取得します。
        /// </summary>
        public static async Task<(long Result, long ResponseCode, byte[] Body)> SendAsync(
            string url, 
            string[] headers, 
            HttpClient.Method method, 
            string requestData = "")
        {
            var httpRequest = new HttpRequest();
            SessionManager.Instance.AddChild(httpRequest);

            var tcs = new TaskCompletionSource<(long result, long responseCode, byte[] body)>(TaskCreationOptions.RunContinuationsAsynchronously);

            void OnCompleted(long result, long responseCode, string[] responseHeaders, byte[] body)
            {
                httpRequest.RequestCompleted -= OnCompleted;
                tcs.SetResult((result, responseCode, body));
            }

            httpRequest.RequestCompleted += OnCompleted;

            Error err = httpRequest.Request(url, headers, method, requestData);
            if (err != Error.Ok)
            {
                httpRequest.QueueFree();
                return ((long)HttpRequest.Result.ConnectionError, 0, System.Array.Empty<byte>());
            }

            var response = await tcs.Task;
            httpRequest.QueueFree();

            return response;
        }
    }
}