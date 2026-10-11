using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Godot;

namespace SKNewRoles2.SNRSystem.Assets
{
    public static class AssetHashManager
    {
        public static async Task<bool> ValidateExistingHashAsync(string hashTxtPath)
        {
            try
            {
                if (!File.Exists(hashTxtPath)) return false;
                string hashContent = (await File.ReadAllTextAsync(hashTxtPath, Encoding.UTF8)).Trim();
                if (!string.IsNullOrEmpty(hashContent) && hashContent.Length == 128)
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"[AssetHashManager] ハッシュ検証エラー: {ex.Message}");
            }
            return false;
        }

        public static string ComputeSha512(string filePath, int bufferSize)
        {
            if (!File.Exists(filePath)) return string.Empty;

            using var sha512 = SHA512.Create();
            using var archiveStream = new FileStream(filePath, FileMode.Open, System.IO.FileAccess.Read, FileShare.Read, bufferSize);
            byte[] hashBytes = sha512.ComputeHash(archiveStream);
            return Convert.ToHexString(hashBytes).ToLower();
        }

        public static void SaveHash(string hashTxtPath, string hash)
        {
            if (!string.IsNullOrEmpty(hash))
            {
                File.WriteAllText(hashTxtPath, hash, Encoding.UTF8);
                GD.Print($"[AssetHashManager] SHA-512ハッシュ値を保存しました: {hashTxtPath}");
            }
        }
    }
}