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
        private const string RemoteHashUrl = "https://github.com/sakitibi/SKNewRoles/releases/download/v4.0.0.0/game_asset.7z.sha512";
        private static readonly string TargetDir = ProjectSettings.GlobalizePath("user://");
        private static readonly string Save7zPath = ProjectSettings.GlobalizePath("user://assets.7z");
        private static readonly string HashTxtPath = ProjectSettings.GlobalizePath("user://assets_sha512.txt");

        public static async Task EnsureAssetsDownloadedAsync(Action<float, string> progressCallback)
        {
            progressCallback?.Invoke(0.0f, "リモートハッシュ値を取得中...");

            var handler = new HttpClientHandler { AllowAutoRedirect = true };
            using var client = new HttpClient(handler);
            client.DefaultRequestHeaders.UserAgent.ParseAdd("GodotGame/1.0");

            string remoteHash = null;
            try
            {
                string fetchedHash = await client.GetStringAsync(RemoteHashUrl);
                remoteHash = fetchedHash.Trim();
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[AssetDownloader] リモートハッシュ取得失敗（オフラインの可能性）: {ex.Message}");
            }

            if (File.Exists(HashTxtPath) && await ValidateExistingHashAsync())
            {
                if (string.IsNullOrEmpty(remoteHash))
                {
                    GD.Print("[AssetDownloader] オフラインまたはリモートハッシュ確認不可のため、既存のアセットを使用します。");
                    progressCallback?.Invoke(1.0f, "アセットロード完了。");
                    return;
                }

                string localHash = (await File.ReadAllTextAsync(HashTxtPath, Encoding.UTF8)).Trim();
                if (remoteHash.Equals(localHash, StringComparison.OrdinalIgnoreCase))
                {
                    GD.Print("[AssetDownloader] ローカルアセットのハッシュがリモートと一致しました。ダウンロードをスキップします。");
                    progressCallback?.Invoke(1.0f, "アセット検証完了。");
                    return;
                }

                GD.Print("[AssetDownloader] リモートアセットの更新（ハッシュ不一致）を検知しました。再ダウンロードを実行します。");
            }

            progressCallback?.Invoke(0.0f, "フォント・アセットのダウンロードを開始中...");

            using HttpResponseMessage response = await client.GetAsync(DirectDownloadUrl, HttpCompletionOption.ResponseHeadersRead);
            response.EnsureSuccessStatusCode();

            long? totalBytes = response.Content.Headers.ContentLength;
            using Stream contentStream = await response.Content.ReadAsStreamAsync();

            {
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
            }

            progressCallback?.Invoke(0.75f, "ファイルを展開中 (7z)...");
            await Task.Run(() =>
            {
                string calculatedHash = string.Empty;

                if (File.Exists(Save7zPath))
                {
                    using var sha512 = SHA512.Create();
                    {
                        using var archiveStream = File.OpenRead(Save7zPath);
                        byte[] hashBytes = sha512.ComputeHash(archiveStream);
                        calculatedHash = Convert.ToHexString(hashBytes);
                    }
                }

                if (File.Exists(Save7zPath))
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
                }

                if (!string.IsNullOrEmpty(calculatedHash))
                {
                    File.WriteAllText(HashTxtPath, calculatedHash, Encoding.UTF8);
                    GD.Print($"[AssetDownloader] SHA-512ハッシュ値を保存しました: {HashTxtPath}");
                }

                if (File.Exists(Save7zPath))
                {
                    File.Delete(Save7zPath);
                }
            });

            progressCallback?.Invoke(1.0f, "アセットの展開が完了しました。");
        }

        private static async Task<bool> ValidateExistingHashAsync()
        {
            try
            {
                string hashContent = (await File.ReadAllTextAsync(HashTxtPath, Encoding.UTF8)).Trim();
                if (!string.IsNullOrEmpty(hashContent) && hashContent.Length == 128)
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[AssetDownloader] ハッシュ検証エラー: {ex.Message}");
            }
            return false;
        }
    }
}