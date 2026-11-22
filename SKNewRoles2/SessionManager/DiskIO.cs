using Godot;
using System;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;

using Environment = System.Environment;

namespace SKNewRoles2.SessionManagerSystem
{
    public static class DiskIO
    {
        private static string TokenFilePath => Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), 
            ".askreditor_token.json"
        );

        private static readonly JsonSerializerOptions DefaultJsonOptions = new()
        {
            WriteIndented = true,
            DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
        };

        public static void SaveSessionToDisk(SessionData session)
        {
            if (session == null) return;

            try
            {
                session.User ??= new();

                string jsonText = JsonSerializer.Serialize(session, DefaultJsonOptions);
                File.WriteAllText(TokenFilePath, jsonText);
                GD.Print($"セッションファイルを保存しました: {TokenFilePath}");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"セッションファイルの保存に失敗: {ex.Message}");
            }
        }

        public static SessionData LoadSessionFromDisk()
        {
            if (!File.Exists(TokenFilePath))
            {
                GD.Print("セッションファイルが見つかりません（初回起動またはログアウト状態）");
                return null;
            }

            try
            {
                string jsonText = File.ReadAllText(TokenFilePath);
                SessionData session = JsonSerializer.Deserialize<SessionData>(jsonText);

                if (session != null && !string.IsNullOrEmpty(session.AccessToken))
                {
                    string email = session.User?.Email ?? $"ID: {session.User?.Id ?? "Unknown"}";
                    GD.Print($"セッションファイルの読み込みに成功！自動ログインしました: {email}");
                    return session;
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"セッションファイルの読み込み・解析に失敗: {ex.Message}");
            }

            return null;
        }

        public static void DeleteSessionFile()
        {
            try
            {
                if (File.Exists(TokenFilePath))
                {
                    File.Delete(TokenFilePath);
                    GD.Print("セッションファイルを削除しました");
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"セッションファイルの削除に失敗: {ex.Message}");
            }
        }
    }
}