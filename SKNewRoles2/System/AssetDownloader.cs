using Godot;
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using SharpCompress.Archives;

using HttpClient = System.Net.Http.HttpClient;
using HttpClientHandler = System.Net.Http.HttpClientHandler;
using HttpCompletionOption = System.Net.Http.HttpCompletionOption;
using HttpResponseMessage = System.Net.Http.HttpResponseMessage;
using FileAccess = System.IO.FileAccess;

namespace SKNewRoles2.SNRSystem
{
    public static class AssetDownloader
    {
        private const string DirectDownloadUrl = "https://github.com/sakitibi/SKNewRoles/releases/download/v4.0.0.0/game_asset.7z";
        private static readonly string TargetDir = ProjectSettings.GlobalizePath("user://");
        private static readonly string Save7zPath = ProjectSettings.GlobalizePath("user://assets.7z");
        private static readonly string HashTxtPath = ProjectSettings.GlobalizePath("user://assets_sha512.txt");

        /// <summary>
        /// 必要なアセットが存在するか確認し、なければダウンロードして解凍する
        /// </summary>
        /// <param name="progressCallback">進捗率(0.0~1.0)とステータスメッセージのコールバック</param>
        public static async Task EnsureAssetsDownloadedAsync(Action<float, string> progressCallback)
        {
            string checkFilePath = Path.Combine(TargetDir, "Fonts", "UDDigiKyokashoProN-Regular.ttf");
            if (File.Exists(checkFilePath))
            {
                GD.Print("[AssetDownloader] フォントファイルが存在するため、ダウンロードをスキップします。");
                progressCallback?.Invoke(1.0f, "アセットチェック完了。");
                return;
            }

            progressCallback?.Invoke(0.0f, "フォント・アセットのダウンロードを開始中...");

            var handler = new HttpClientHandler { AllowAutoRedirect = true };
            using var client = new HttpClient(handler);
            client.DefaultRequestHeaders.UserAgent.ParseAdd("GodotGame/1.0");

            using HttpResponseMessage response = await client.GetAsync(DirectDownloadUrl, HttpCompletionOption.ResponseHeadersRead);
            response.EnsureSuccessStatusCode();

            long? totalBytes = response.Content.Headers.ContentLength;
            using Stream contentStream = await response.Content.ReadAsStreamAsync();
            using FileStream fileStream = new(
                Save7zPath, FileMode.Create, FileAccess.Write, FileShare.None, 8192, true
            );

            byte[] buffer = new byte[8192];
            long totalReadBytes = 0;
            int readBytes;

            while ((readBytes = await contentStream.ReadAsync(buffer.AsMemory())) > 0)
            {
                await fileStream.WriteAsync(buffer.AsMemory(0, readBytes));
                totalReadBytes += readBytes;

                if (totalBytes.HasValue && totalBytes.Value > 0)
                {
                    float downloadProgress = (float)totalReadBytes / totalBytes.Value;
                    string mbRead = (totalReadBytes / 1024f / 1024f).ToString("F1");
                    string mbTotal = (totalBytes.Value / 1024f / 1024f).ToString("F1");
                    
                    progressCallback?.Invoke(downloadProgress * 0.7f, $"ダウンロード中... ({mbRead} MB / {mbTotal} MB)");
                }
            }

            progressCallback?.Invoke(0.75f, "ファイルを展開中 (7z)...");
            await Task.Run(() =>
            {
                using var stream = File.OpenRead(Save7zPath);
                using var archive = ArchiveFactory.OpenArchive(stream);

                foreach (var entry in archive.Entries)
                {
                    if (!entry.IsDirectory)
                    {
                        entry.WriteToDirectory(TargetDir, new SharpCompress.Common.ExtractionOptions
                        {
                            ExtractFullPath = true,
                            Overwrite = true
                        });
                    }
                }

                stream.Close();

                if (File.Exists(Save7zPath))
                {
                    using (var sha512 = SHA512.Create())
                    using (var archiveStream = File.OpenRead(Save7zPath))
                    {
                        byte[] hashBytes = sha512.ComputeHash(archiveStream);
                        string hashString = Convert.ToHexString(hashBytes); // 16進数文字列に変換

                        File.WriteAllText(HashTxtPath, hashString, Encoding.UTF8);
                        GD.Print($"[AssetDownloader] SHA-512ハッシュ値を保存しました: {HashTxtPath}");
                    }

                    File.Delete(Save7zPath);
                }
            });

            progressCallback?.Invoke(1.0f, "アセットの展開が完了しました。");
        }
    }
}