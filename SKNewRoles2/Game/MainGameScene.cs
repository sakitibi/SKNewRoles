using Godot;
using System;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory;

namespace SKNewRoles2.Game
{
    public partial class MainGameScene : Node3D
    {
        private Node3D _chunkManagerCpp;

        private PackedScene _playerScene = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");
        private PackedScene _opponentScene = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");

        public Node3D MyPlayerInstance => _myPlayerInstance;
        private Node3D _myPlayerInstance;
        public Node HealthComponent => _healthComponent;
        private Node _healthComponent;
        
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        public GameUIController UIController => _uiController;
        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        
        // HotbarManager への参照を追加
        [Export] private HotbarManager _hotbarManager;

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

            if (_myPlayerInstance == null)
            {
                SpawnMyPlayer();
                SetPlayerPhysicsEnabled(false);
                _myPlayerInstance.Visible = false;
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
                _roleManager.Initialize(GetNodeOrNull<Node>("RoleManager"));

                _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

                // HotbarManager が未割り当ての場合はノードを検索
                _hotbarManager ??= GetNodeOrNull<HotbarManager>("HotbarManager");

                _remotePlayerManager = new RemotePlayerManager();
                AddChild(_remotePlayerManager);
                _remotePlayerManager.Initialize(_opponentScene, GetMyUserId());

                await WaitForInitialChunksLoaded();

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

            // 初期アイテムの配布
            GrantInitialItems();

            if (_uiController != null)
            {
                await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, displayTimeMs: 5000);
            }

            SetPlayerPhysicsEnabled(true);
        }

        /// <summary>
        /// ゲーム開始時に全員（自クライアント）に初期ツールを配布する
        /// </summary>
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

        private void SpawnMyPlayer()
        {
            if (_playerScene == null)
            {
                GD.PrintErr("❌ [MainGameScene] Player.tscn のロードに失敗しています。");
                return;
            }

            _myPlayerInstance = _playerScene.Instantiate<Node3D>();
            _myPlayerInstance.Name = "MyPlayer";
            AddChild(_myPlayerInstance);

            Vector3 spawnPos = new(0, 100, 0);
            _myPlayerInstance.GlobalPosition = spawnPos;

            SetPlayerPhysicsEnabled(false);

            _healthComponent = _myPlayerInstance.GetNodeOrNull<Node>("HealthComponent");
            Node targetNode = _healthComponent ?? _myPlayerInstance;

            string[] signalNames = ["HpChanged", "hp_changed", "HealthChanged", "health_changed"];
            foreach (var sig in signalNames)
            {
                if (targetNode.HasSignal(sig))
                {
                    targetNode.Connect(sig, Callable.From<int, int>(_networkHandler.OnMyPlayerHpChanged));
                    break;
                }
            }

            _networkHandler?.UpdateHpUIFromPlayer();
            GD.Print($"👤 [MainGameScene] 自プレイヤーを生成しました。(Pos: {spawnPos})");
        }

        private async Task WaitForInitialChunksLoaded()
        {
            int timeoutMs = 10000;
            int elapsedMs = 0;
            int checkIntervalMs = 100;

            if (_chunkManagerCpp == null)
            {
                GD.PrintErr("❌ [MainGameScene] ChunkManager ノードが見つかりません。");
                return;
            }

            if (!_chunkManagerCpp.HasMethod("is_initial_load_complete"))
            {
                GD.PrintErr("❌ [MainGameScene] ChunkManager に 'is_initial_load_complete' メソッドがバインドされていません。");
                return;
            }

            while (elapsedMs < timeoutMs)
            {
                Variant res = _chunkManagerCpp.Call("is_initial_load_complete");

                if (res.VariantType == Variant.Type.Bool && (bool)res)
                {
                    GD.Print($"✅ [MainGameScene] チャンクの初期読込が完了しました ({elapsedMs}ms経過)。");
                    return;
                }

                await Task.Delay(checkIntervalMs);
                elapsedMs += checkIntervalMs;
            }

            GD.PrintErr("⚠️ [MainGameScene] チャンク初期読込がタイムアウトしました。処理を続行します。");
        }

        private void SetPlayerPhysicsEnabled(bool enabled)
        {
            if (_myPlayerInstance == null || !IsInstanceValid(_myPlayerInstance)) return;

            if (_myPlayerInstance.HasMethod("set_movement_enabled"))
            {
                _myPlayerInstance.Call("set_movement_enabled", enabled);
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

        public void StopBGM()
        {
            _bgmManager?.StopBgm();
        }

        public void SetRemotePlayerHp(int currentHp)
        {
            _remotePlayerManager?.SetMyHp(currentHp);
        }
    }
}