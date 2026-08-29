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

        public Node3D MyPlayerInstance => _myPlayerInstance;
        private Node3D _myPlayerInstance;

        public Node HealthComponent => _healthComponent;
        private Node _healthComponent;
        
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        public GameUIController UIController => _uiController;
        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        private HotbarManager _hotbarManager;

        public RealtimeConnection Connection => _connection;
        private readonly RealtimeConnection _connection = new();
        
        private MainGameSceneNetwork _networkHandler;
        private readonly PlayerSpawner _playerSpawner = new();
        private readonly ChunkLoader _chunkLoader = new();

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

            if (_myPlayerInstance == null)
            {
                (_myPlayerInstance, _healthComponent) = _playerSpawner.SpawnMyPlayer(this, _networkHandler);
                _playerSpawner.SetPlayerPhysicsEnabled(_myPlayerInstance, false);
                if (_myPlayerInstance != null) _myPlayerInstance.Visible = false;
            }

            try
            {
                bool isConnected = await _connection.EnsureConnectedAsync();
                if (!isConnected)
                {
                    GD.PrintErr("❌ [Realtime] MainGameScene での WebSocket 接続に失敗しました。");
                }

                _roleManager = new GameRoleManager();
                AddChild(_roleManager);
                _roleManager.Initialize(GetNode<Node>("RoleManager"));

                _chunkManagerCpp = GetNode<Node3D>("ChunkManager");

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

                _remotePlayerManager = new RemotePlayerManager();
                AddChild(_remotePlayerManager);
                _remotePlayerManager.Initialize(_opponentScene, GetMyUserId());

                await _chunkLoader.WaitForInitialChunksLoadedAsync(_chunkManagerCpp);

                if (SessionManager.Instance != null && SessionManager.Instance.IsHost)
                {
                    await _roleManager.AssignRolesToAllPlayers(GetMyUserId());
                }

                bool received = await _roleManager.WaitForRoleAssignedAsync(timeoutMs: 10000);
                if (!received)
                {
                    GD.PrintErr("⚠️ 役職受信タイムアウトのため、デフォルト(村人)を適用します");
                    _roleManager.ApplyRole(0, 0);
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"❌ [_Ready] 初期化待機中にエラーが発生しました: {ex.Message}");
            }
            finally
            {
                _uiController?.HideLoadingScene();
            }

            if (_myPlayerInstance != null && IsInstanceValid(_myPlayerInstance))
            {
                _myPlayerInstance.Visible = true;
            }

            _bgmManager?.PlayRandomBgm(0.0f);
            GrantInitialItems();

            if (_uiController != null)
            {
                await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, displayTimeMs: 5000);
            }

            _playerSpawner.SetPlayerPhysicsEnabled(_myPlayerInstance, true);
        }

        private void GrantInitialItems()
        {
            if (_hotbarManager != null)
            {
                _hotbarManager.PickupItem("iron_axe", 1);
                _hotbarManager.PickupItem("iron_pickaxe", 1);
                GD.Print("🎒 [MainGameScene] 初期アイテム (iron_axe, iron_pickaxe) を配布しました。");
            }
            else
            {
                GD.PrintErr("⚠️ [MainGameScene] HotbarManager が見つからないため、初期アイテムを配布できませんでした。");
            }
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

            if (_myPlayerInstance != null && IsInstanceValid(_myPlayerInstance))
            {
                _uiController?.UpdateCoords(_myPlayerInstance.GlobalPosition);

                _networkHandler?.UpdateHpUIFromPlayer();

                if (_myPlayerInstance.Visible)
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