using Godot;
using System;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory;
using SKNewRoles2.Game.Player;
using SKNewRoles2.Game.BGM;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class MainGameScene : Node3D
    {
        private Node3D _chunkManagerCpp;
        private readonly PackedScene _opponentScene = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");

        private readonly PlayerSpawner _playerSpawner = new();
        private MainGamePlayerHandler _playerHandler;
        private MainGameCombatHandler _combatHandler;
        private MainGameUIHandler _uiHandler;
        private MainGameNetworkHandler _networkHandler;

        public Node3D MyPlayerInstance => _playerHandler?.MyPlayerInstance;
        public Node HealthComponent => _playerHandler?.HealthComponent;
        private Node _hotbarNode;
        
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        public GameUIController UIController => _uiController;
        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        private HotbarManager _hotbarManager;

        public RealtimeConnection Connection => _connection;
        private readonly RealtimeConnection _connection = new();

        public int CurrentHp { get; set; } = 20;
        public int MaxHp { get; set; } = 20;
        public uint MyRole => _roleManager?.MyRole ?? 0;
        public uint MyFaction => _roleManager?.MyFaction ?? 0;
        public int CurrentHunger { get; set; } = 20;
        public int MaxHunger { get; set; } = 20;
        public Dictionary<string, ushort> GrantItemDic { get; set; } = new() {
            {"iron_axe", 1},
            {"iron_pickaxe", 1}
        };

        private readonly uint[] BGMList = [0, 1];

        public override async void _Ready()
        {
            GD.Print("[_Ready] 開始");

            _playerHandler = new MainGamePlayerHandler(this);
            _uiHandler = new MainGameUIHandler(this);
            _networkHandler = new MainGameNetworkHandler(this);
            _combatHandler = new MainGameCombatHandler(this, _networkHandler);

            _networkHandler.RegisterEvents(_connection);

            _bgmManager = new BGMManager();
            AddChild(_bgmManager);

            _uiController = new GameUIController();
            AddChild(_uiController);
            await _uiController.Initialize(this);
            _uiController.SetFpsLabelPathToHud("FPSText");
            _uiController.SetLabelPathToHud("PositionText");

            _roleManager = new GameRoleManager();
            AddChild(_roleManager);

            _remotePlayerManager = new RemotePlayerManager();
            AddChild(_remotePlayerManager);

            _chunkManagerCpp = GetNode<Node3D>("ChunkManager");

            await _playerHandler.SpawnPlayerAsync(_networkHandler);
            _playerHandler.SetupHungerSignal(_networkHandler);

            _hotbarManager = GetNodeOrNull<HotbarManager>("HotbarManager");
            _hotbarNode = GetNodeOrNull<Node>("Hotbar");
            if (_hotbarManager != null)
            {
                _hotbarManager.Initialize(this, _hotbarNode);
            }
            else
            {
                GD.PrintErr("❌ [MainGameScene] HotbarManager ノードが見つかりません。");
            }

            await GameInitializer.InitializeAsync(
                this,
                _connection,
                _roleManager,
                _remotePlayerManager,
                _opponentScene,
                _chunkManagerCpp,
                _uiController
            );

            _ = _bgmManager?.PlayBgm(0.0f, BGMList);
            PlayerManager.GrantInitialItems(_hotbarManager, GrantItemDic);

            if (_uiController != null)
            {
                await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, 5000);
                PlayerSpawner.SetPlayerPhysicsEnabled(_playerHandler.MyPlayerInstance, true);
            }
        }

        public override void _Input(InputEvent @event)
        {
            _combatHandler?.HandleInput(@event);
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

            _ = _uiHandler?.UpdateCoordsUI();
            _ = _uiHandler?.UpdateHpUIFromPlayer();
            _uiHandler?.UpdateHungerUIFromPlayer();

            _networkHandler?.ProcessMovementSync();
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

            if (_connection != null && _networkHandler != null)
            {
                _networkHandler.UnregisterEvents(_connection);
            }

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