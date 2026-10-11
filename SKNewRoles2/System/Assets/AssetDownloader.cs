using System;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using Godot;

namespace SKNewRoles2.SNRSystem.Assets
{
    public static class AssetDownloader
    {
        private const string GHUrlBase = "https://github.com/sakitibi/SKNewRoles/releases/download/v4.0.0.0/";
        private static readonly string DirectDownloadUrl = $"{GHUrlBase}game_asset.7z";
        private static readonly string RemoteHashUrl = $"{GHUrlBase}game_asset.7z.sha512";
        private static readonly string TargetDir = ProjectSettings.GlobalizePath("user://");
        private static readonly string Save7zPath = ProjectSettings.GlobalizePath("user://assets.7z");
        private static readonly string HashTxtPath = ProjectSettings.GlobalizePath("user://assets_sha512.txt");

        private const int BufferSize = 1024 * 1024;
        private const ulong ProgressUpdateIntervalMs = 50;

        public static async Task EnsureAssetsDownloadedAsync(Action<float, string> progressCallback)
        {
            progressCallback?.Invoke(0.0f, "リモートハッシュ値を取得中...");

            string remoteHash = await AssetNetworkClient.FetchRemoteHashAsync(RemoteHashUrl);

            if (File.Exists(HashTxtPath) && await AssetHashManager.ValidateExistingHashAsync(HashTxtPath))
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
            await AssetNetworkClient.DownloadFileAsync(DirectDownloadUrl, Save7zPath, BufferSize, ProgressUpdateIntervalMs, progressCallback);

            progressCallback?.Invoke(0.75f, "ファイルを高速展開中 (7z)...");
            await Task.Run(() =>
            {
                string calculatedHash = AssetHashManager.ComputeSha512(Save7zPath, BufferSize);
                AssetExtractor.Extract7z(Save7zPath, TargetDir, BufferSize);
                AssetHashManager.SaveHash(HashTxtPath, calculatedHash);

                if (File.Exists(Save7zPath))
                {
                    File.Delete(Save7zPath);
                }
            });

            progressCallback?.Invoke(1.0f, "アセットの展開が完了しました。");
        }
    }
}