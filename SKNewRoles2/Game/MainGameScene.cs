using Godot;
using System;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory;

namespace SKNewRoles2.Game
{
    public partial class MainGameScene : Node3D
    {
        private Node3D _chunkManagerCpp;
        private readonly PackedScene _opponentScene = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");

        private readonly PlayerManager _playerManager = new();
        private readonly GameInitializer _initializer = new();

        public Node3D MyPlayerInstance => _playerManager.MyPlayerInstance;
        public Node HealthComponent => _playerManager.HealthComponent;
        
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        public GameUIController UIController => _uiController;
        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        private HotbarManager _hotbarManager;

        public RealtimeConnection Connection => _connection;
        private readonly RealtimeConnection _connection = new();
        
        private MainGameSceneNetwork _networkHandler;

        public int CurrentHp { get => _currentHp; set => _currentHp = value; }
        private int _currentHp = 20;
        public int MaxHp { get => _maxHp; set => _maxHp = value; }
        private int _maxHp = 20;

        public int MyRole => _roleManager?.MyRole ?? -1;
        public int MyFaction => _roleManager?.MyFaction ?? -1;

        public override async void _Ready()
        {
            GD.Print("[_Ready] 開始");

            _networkHandler = new MainGameSceneNetwork(this);

            _bgmManager = new BGMManager();
            AddChild(_bgmManager);

            _uiController = new GameUIController();
            AddChild(_uiController);
            _uiController.Initialize(this);

            _roleManager = new GameRoleManager();
            AddChild(_roleManager);

            _remotePlayerManager = new RemotePlayerManager();
            AddChild(_remotePlayerManager);

            _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

            _playerManager.SpawnPlayer(this, _networkHandler, _chunkManagerCpp);

            _hotbarManager = GetNodeOrNull<HotbarManager>("HotbarManager");
            var hotbarNode = GetNodeOrNull<Node>("Hotbar");
            
            if (_hotbarManager != null)
            {
                _hotbarManager.Initialize(this, hotbarNode);
            }
            else
            {
                GD.PrintErr("❌ [MainGameScene] HotbarManager ノードが見つかりません。");
            }

            // 非同期初期化処理の実行
            await _initializer.InitializeAsync(
                this,
                _connection,
                _roleManager,
                _remotePlayerManager,
                _opponentScene,
                _chunkManagerCpp,
                _uiController
            );

            _playerManager.SetVisible(true);

            _bgmManager?.PlayRandomBgm(0.0f);
            _playerManager.GrantInitialItems(_hotbarManager);

            if (_uiController != null)
            {
                await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, displayTimeMs: 5000);
            }

            _playerManager.EnablePhysics();
        }

        public override void _Process(double delta)
        {
            try
            {
                _connection?.Poll();
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] Poll 例外: {ex.Message}");
            }

            var player = MyPlayerInstance;
            if (player != null && IsInstanceValid(player))
            {
                _uiController?.UpdateCoords(player.GlobalPosition);

                _networkHandler?.UpdateHpUIFromPlayer();

                if (player.Visible)
                {
                    _networkHandler?.SendMyTransform();
                }
            }
        }

        public static string GetMyUserId()
        {
            string myUserId = SessionManager.Instance?.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance?.CurrentRoomCode ?? "SingleTest"}";
            }
            return myUserId;
        }

        public override void _ExitTree()
        {
            SetProcess(false);

            GD.Print("🚪 [MainGameScene] _ExitTree: シーン破棄のため通信とBGMを安全に停止します。");
            _bgmManager?.StopBgm();

            try
            {
                _connection?.Close();
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [MainGameScene] 通信切断エラー (無視): {ex.Message}");
            }

            base._ExitTree();
        }

        public void StopBGM() => _bgmManager?.StopBgm();

        public void SetRemotePlayerHp(int currentHp) => _remotePlayerManager?.SetMyHp(currentHp);
    }
}