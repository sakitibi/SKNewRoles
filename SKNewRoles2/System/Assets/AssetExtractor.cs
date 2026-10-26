using System;
using System.IO;
using System.Threading.Tasks;
using Godot;
using SharpCompress.Archives;
using SharpCompress.Archives.SevenZip;
using SharpCompress.Common;

namespace SKNewRoles2.SNRSystem.Assets
{
    public static class AssetExtractor
    {
        private static FileStream _stream;
        private static IArchive _archive;
        public static async Task Extract7z(string archivePath, string targetDir, int bufferSize)
        {
            if (!File.Exists(archivePath)) return;

            try
            {
                _stream = new(archivePath, FileMode.Open, System.IO.FileAccess.Read, FileShare.Read, bufferSize);
                _archive = SevenZipArchive.OpenArchive(_stream);

                var extractionOptions = new ExtractionOptions
                {
                    ExtractFullPath = true,
                    Overwrite = true
                };

                foreach (var entry in _archive.Entries)
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