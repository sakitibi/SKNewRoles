using Godot;
using System;
using System.Text.Json;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;

namespace SKNewRoles2.Lobby.JOIN.Services
{
    public static class LobbyManagementService
    {
        /// <summary>
        /// サーバー側のロビーの公開/非公開（is_public）設定を更新します。
        /// </summary>
        public static async Task<bool> UpdateLobbyPrivacyAsync(string roomCode, bool isPublic)
        {
            if (SessionManager.Instance.CurrentSession == null || string.IsNullOrEmpty(SessionManager.Instance.CurrentSession.AccessToken)) 
                return false;

            string escapedCode = Uri.EscapeDataString(roomCode.Trim());
            string url = $"{SessionManager.SupabaseUrl}/rest/v1/lobbies?room_code=eq.{escapedCode}";

            string[] headers = [
                $"apikey: {SessionManager.SupabaseAnonKey}",
                $"Authorization: Bearer {SessionManager.Instance.CurrentSession.AccessToken}",
                "Content-Type: application/json",
                "Prefer: return=representation"
            ];

            var payload = new { is_public = isPublic };
            string jsonBody = JsonSerializer.Serialize(payload);

            var (res, code, _) = await HttpRequestHelper.SendAsync(url, headers, HttpClient.Method.Patch, jsonBody);

            if (res == (long)HttpRequest.Result.Success && (code == 200 || code == 204))
            {
                SessionManager.Instance.IsPublic = isPublic; 
                return true;
            }
            return false;
        }
    }
}