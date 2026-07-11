using Godot;
using System;
using System.Collections.Generic;

namespace SKNewRoles2.SessionManagerSystem
{
    /// <summary>
    /// 外部のMODや別アセンブリから完全にアクセス可能な、ゲームのコアセッションマネージャー
    /// </summary>
    public partial class SessionManager : Node
    {
        // ==========================================
        // 1. MOD向けプロパティ（自由に変更・取得が可能）
        // ==========================================
        public string CurrentRoomCode { get; set; } = "";
        public string CurrentRoomName { get; set; } = "";
        public bool IsHost { get; set; } = false;
        public bool IsPublic { get; set; } = true;
        public List<string> CurrentRoomPlayerIds { get; set; } = new List<string>();

        public SessionData CurrentSession { get; private set; }
        public bool IsLoggedIn => CurrentSession != null;
        
        // MODがユーザー更新タイミングを検知するためのイベント
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

        // ==========================================
        // 2. 外部MODアセンブリ対応型 シングルトン構造
        // ==========================================
        private static SessionManager _instance;

        /// <summary>
        /// MODを含む、すべての外部スクリプトからこのシステムにアクセスするための唯一の窓口。
        /// 型の競合やアセンブリの差異を無視して、確実にゲーム本体のインスタンスを返します。
        /// </summary>
        public static SessionManager Instance
        {
            get
            {
                // すでにキャッシュがある場合はそれを即座に返す
                if (_instance != null && IsInstanceValid(_instance))
                {
                    return _instance;
                }

                var mainLoop = Engine.GetMainLoop();
                if (mainLoop is SceneTree tree)
                {
                    Node node = tree.Root.GetNodeOrNull("SessionManager");
                    if (node is SessionManager manager)
                    {
                        _instance = manager;
                    }
                    else if (node != null)
                    {
                        _instance = node as SessionManager;
                    }

                    // ツリー上に存在しない場合は、ゲーム本体のルート配下に生成
                    if (_instance == null)
                    {
                        GD.Print("[MOD API] SessionManagerをオートロード空間に動的生成します。");
                        _instance = new SessionManager { Name = "SessionManager" };
                        tree.Root.AddChild(_instance); 
                    }
                }
                return _instance;
            }
        }

        // ==========================================
        // 3. ライフサイクル
        // ==========================================
        public override void _Ready()
        {
            if (_instance == null)
            {
                _instance = this;
            }
            else if (_instance != this)
            {
                QueueFree();
                return;
            }

            LoadSessionFromDisk();
        }

        private static void FetchConfigFromCpp()
        {
            if (ClassDB.ClassExists("ConfigManager"))
            {
                using var configObj = ClassDB.Instantiate("ConfigManager").As<Node>();
                if (configObj != null)
                {
                    _cachedSupabaseUrl = configObj.Call("get_supabase_url").AsString();
                    _cachedSupabaseAnonKey = configObj.Call("get_supabase_key").AsString();
                    GD.Print("🔐 [C++ Config] C++ 側から Supabase 設定情報を安全にロードしました。");
                    return;
                }
            }
            GD.PrintErr("❌ [C++ Config] ConfigManager クラスが見つかりません。C++ モジュールのビルドを確認してください。");
        }

        public void SetSession(SessionData session)
        {
            CurrentSession = session;
            string email = session.User?.Email ?? $"ID: {session.User?.Id ?? "Unknown"}";
            GD.Print($"👤 [MOD] セッションがセットされました: {email}");
            
            SaveSessionToDisk();
            StartUserInfoSync();
        }

        public void ClearSession()
        {
            CurrentSession = null;
            DeleteSessionFile();
            GD.Print("🚪 [MOD] セッションがクリアされました。");
            UserInfoUpdated?.Invoke();
        }
    }
}