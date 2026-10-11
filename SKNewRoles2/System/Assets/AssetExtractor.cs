using System;
using System.IO;
using Godot;
using SharpCompress.Archives;
using SharpCompress.Archives.SevenZip;
using SharpCompress.Common;

namespace SKNewRoles2.SNRSystem.Assets
{
    public static class AssetExtractor
    {
        public static void Extract7z(string archivePath, string targetDir, int bufferSize)
        {
            if (!File.Exists(archivePath)) return;

            try
            {
                using var stream = new FileStream(archivePath, FileMode.Open, System.IO.FileAccess.Read, FileShare.Read, bufferSize);
                using var archive = SevenZipArchive.OpenArchive(stream);

                var extractionOptions = new ExtractionOptions
                {
                    ExtractFullPath = true,
                    Overwrite = true
                };

                foreach (var entry in archive.Entries)
                {
                    if (!entry.IsDirectory)
                    {
                        entry.WriteToDirectory(targetDir, extractionOptions);
                    }
                }

                GD.Print("[AssetExtractor] 7zファイルの解凍が正常に完了しました。");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[AssetExtractor] 解凍中にエラーが発生しました: {ex.Message}");
            }
        }
    }
}