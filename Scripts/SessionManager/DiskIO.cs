using Godot;
using System;
using System.IO;
using System.Text.Json;

namespace SKNewRoles2.SessionManagerSystem
{
    public partial class SessionManager : Node
    {
        private string TokenFilePath => Path.Combine(
            System.Environment.GetFolderPath(System.Environment.SpecialFolder.UserProfile), 
            ".askreditor_token.json"
        );

        // ==========================================
        // 4. ディスク I/O ヘルパー関数 (ローカルファイル関連)
        // ==========================================
        private void SaveSessionToDisk()
        {
            if (CurrentSession == null) return;

            try
            {
                EnsureUserObjectInitialized();

                var options = new JsonSerializerOptions 
                { 
                    WriteIndented = true,
                    DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull
                };

                string jsonText = JsonSerializer.Serialize(CurrentSession, options);
                File.WriteAllText(TokenFilePath, jsonText);
                GD.Print($"💾 セッションファイルを保存しました: {TokenFilePath}");
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ セッションファイルの保存に失敗: {ex.Message}");
            }
        }

        private void LoadSessionFromDisk()
        {
            if (!File.Exists(TokenFilePath))
            {
                GD.Print("ℹ️ セッションファイルが見つかりません（初回起動またはログアウト状態）");
                return;
            }

            try
            {
                string jsonText = File.ReadAllText(TokenFilePath);
                var session = JsonSerializer.Deserialize<SessionData>(jsonText);

                if (session != null && !string.IsNullOrEmpty(session.AccessToken))
                {
                    CurrentSession = session;
                    string email = session.User?.Email ?? $"ID: {session.User?.Id ?? "Unknown"}";
                    GD.Print($"✨ セッションファイルの読み込みに成功！自動ログインしました: {email}");
                    
                    StartUserInfoSync();
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ セッションファイルの読み込み・解析に失敗: {ex.Message}");
            }
        }

        private void DeleteSessionFile()
        {
            try
            {
                if (File.Exists(TokenFilePath))
                {
                    File.Delete(TokenFilePath);
                    GD.Print("🗑️ セッションファイルを削除しました");
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ セッションファイルの削除に失敗: {ex.Message}");
            }
        }

        private void EnsureUserObjectInitialized()
        {
            if (CurrentSession != null && CurrentSession.User == null)
            {
                CurrentSession.User = new UserInfo();
            }
        }
    }
}