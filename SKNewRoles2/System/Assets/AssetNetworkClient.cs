using System;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using Godot;

using HttpClient = System.Net.Http.HttpClient;

namespace SKNewRoles2.SNRSystem.Assets
{
    public static class AssetNetworkClient
    {
        public static async Task<string> FetchRemoteHashAsync(string remoteHashUrl)
        {
            var handler = new HttpClientHandler { AllowAutoRedirect = true };
            using var client = new HttpClient(handler);
            client.DefaultRequestHeaders.UserAgent.ParseAdd("GodotGame/1.0");

            try
            {
                string fetchedHash = await client.GetStringAsync(remoteHashUrl);
                return fetchedHash.Trim();
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[AssetNetworkClient] リモートハッシュ取得失敗（オフラインの可能性）: {ex.Message}");
                return null;
            }
        }

        public static async Task DownloadFileAsync(string downloadUrl, string savePath, int bufferSize, ulong updateIntervalMs, Action<float, string> progressCallback)
        {
            var handler = new HttpClientHandler { AllowAutoRedirect = true };
            using var client = new HttpClient(handler);
            client.DefaultRequestHeaders.UserAgent.ParseAdd("GodotGame/1.0");

            using HttpResponseMessage response = await client.GetAsync(downloadUrl, HttpCompletionOption.ResponseHeadersRead);
            response.EnsureSuccessStatusCode();

            long? totalBytes = response.Content.Headers.ContentLength;
            using Stream contentStream = await response.Content.ReadAsStreamAsync();
            using FileStream fileStream = new(savePath, FileMode.Create, System.IO.FileAccess.Write, FileShare.None, bufferSize, true);

            byte[] buffer = new byte[bufferSize];
            long totalReadBytes = 0;
            int readBytes;
            ulong lastReportTime = Time.GetTicksMsec();

            while ((readBytes = await contentStream.ReadAsync(buffer.AsMemory())) > 0)
            {
                await fileStream.WriteAsync(buffer.AsMemory(0, readBytes));
                totalReadBytes += readBytes;

                ulong currentTime = Time.GetTicksMsec();
                if (totalBytes.HasValue && totalBytes.Value > 0 && (currentTime - lastReportTime >= updateIntervalMs))
                {
                    lastReportTime = currentTime;
                    float downloadProgress = (float)totalReadBytes / totalBytes.Value;
                    string mbRead = (totalReadBytes / 1024f / 1024f).ToString("F1");
                    string mbTotal = (totalBytes.Value / 1024f / 1024f).ToString("F1");
                    
                    progressCallback?.Invoke(downloadProgress * 0.7f, $"ダウンロード中... ({mbRead} MB / {mbTotal} MB)");
                }
            }
        }
    }
}