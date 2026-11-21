using Godot;
using System;
using System.Collections.Generic;
using SKNewRoles2.SessionManagerSystem.Services;

namespace SKNewRoles2.SessionManagerSystem
{
    public partial class SessionManager : Node
    {
        public string CurrentRoomCode { get; set; } = "";
        public string CurrentRoomName { get; set; } = "";
        public bool IsHost { get; set; } = false;
        public bool IsPublic { get; set; } = true;
        public List<string> CurrentRoomPlayerIds { get; set; } = [];

        public SessionData CurrentSession { get; set; }
        public bool IsLoggedIn => CurrentSession != null;
        
        public event Action UserInfoUpdated;

        public int MyRole { get; set; } = -1;
        public int MyFaction { get; set; } = -1;

        private static string _cachedSupabaseUrl = null;
        private static string _cachedSupabaseAnonKey = null;

        public static string SupabaseUrl
        {
            get
            {
                if (string.IsNullOrEmpty(_cachedSupabaseUrl))
                {
                    FetchConfigFromCpp();
                }
                return _cachedSupabaseUrl ?? "";
            }
        }

        public static string SupabaseAnonKey
        {
            get
            {
                if (string.IsNullOrEmpty(_cachedSupabaseAnonKey))
                {
                    FetchConfigFromCpp();
                }
                return _cachedSupabaseAnonKey ?? "";
            }
        }

        /// <summary>
        /// 静的キャッシュを持たず、オートロード空間から常に安全にインスタンスを取得します。
        /// </summary>
        public static SessionManager Instance
        {
            get
            {
                MainLoop mainLoop = Engine.GetMainLoop();
                if (mainLoop is SceneTree tree)
                {
                    return tree.Root.GetNodeOrNull<SessionManager>("SessionManager");
                }
                return null;
            }
        }

        public override async void _Ready()
        {
            CurrentSession = DiskIO.LoadSessionFromDisk();
            if (CurrentSession != null)
            {
                string email = CurrentSession.User?.Email ?? $"ID: {CurrentSession.User?.Id ?? "Unknown"}";
                GD.Print($"✨ セッションファイルの読み込みに成功！自動ログインしました: {email}");
                await UserInfoService.StartUserInfoSync();
            }
        }

        public override void _ExitTree()
        {
            UserInfoService.CancelAll();
        }

        private static void FetchConfigFromCpp()
        {
            if (ClassDB.ClassExists("ConfigManager"))
            {
                using Node configObj = ClassDB.Instantiate("ConfigManager").As<Node>();
                if (configObj != null)
                {
                    _cachedSupabaseUrl = configObj.Call("get_supabase_url").AsString();
                    _cachedSupabaseAnonKey = configObj.Call("get_supabase_key").AsString();
                    GD.Print("🔐 [C++ Config] C++ 側から Supabase 設定情報を安全にロードしました。");
                    return;
                }
            }
            GD.PrintErr("❌ [C++ Config] ConfigManager クラスが見つかりません。");
        }

        public void SetSession(SessionData session)
        {
            CurrentSession = session;
            string email = session.User?.Email ?? $"ID: {session.User?.Id ?? "Unknown"}";
            GD.Print($"👤 [MOD] セッションがセットされました: {email}");
            
            DiskIO.SaveSessionToDisk(CurrentSession);
            _ = UserInfoService.StartUserInfoSync();
        }

        public void ClearSession()
        {
            CurrentSession = null;
            DiskIO.DeleteSessionFile();
            GD.Print("🚪 [MOD] セッションがクリアされました。");
            UserInfoUpdated?.Invoke();
        }
    }
}