using Godot;
using System;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory;
using SKNewRoles2.Game.Player;
using SKNewRoles2.Game.BGM;
using System.Collections.Generic;
using SKNewRoles2.Game.Player.Handler;
using SKNewRoles2.Game.Inventory.Item;
using SKNewRoles2.Game.Skill;
using SKNewRoles2.Game.Skill.Witch.Witch;
using SKNewRoles2.Lobby.UI;

namespace SKNewRoles2.Game
{
    public partial class MainGameScene : Node3D
    {
        private Node3D _chunkManagerCpp;
        private readonly PackedScene _opponentScene = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");
        
        [Export] private PackedScene _menuScene;
        private Control _activeMenuInstance;

        private MainGamePlayerHandler _playerHandler;
        private MainGameCombatHandler _combatHandler;
        private MainGameUIHandler _uiHandler;
        private MainGameNetworkHandler _networkHandler;
        private PlayerCombatSyncHandler _playerCombatSyncHandler;
        private PlayerTransformSyncHandler _playerTransformSyncHandler;
        private PlayerStatusSyncHandler _playerStatusSyncHandler;

        public Node3D MyPlayerInstance => _playerHandler?.MyPlayerInstance;
        public Node HealthComponent => _playerHandler?.HealthComponent;
        private Node _hotbarNode;
        
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        public GameUIController UIController => _uiController;
        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        private HotbarManager _hotbarManager;
        private PlayerManager _playerManager;
        private PlayerSpawner _playerSpawner;
        private WitchMagic _witchMagic;

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
            {"iron_pickaxe", 1},
        };

        private readonly uint[] BGMList = [0, 1];

        public override async void _Ready()
        {
            GD.Print("[_Ready] 開始");

            _playerCombatSyncHandler = new(this);
            _playerTransformSyncHandler = new(this);
            _playerStatusSyncHandler = new(this);

            _playerHandler = new(this);
            _uiHandler = new(this);
            _networkHandler = new(this);
            _combatHandler = new(this, _playerCombatSyncHandler);
            _playerSpawner = new(this);
            _playerManager = new(this);

            _witchMagic = new(this, _playerCombatSyncHandler);

            _networkHandler.RegisterEvents(_connection);

            _bgmManager = new();
            AddChild(_bgmManager);

            _uiController = new();
            AddChild(_uiController);
            await _uiController.Initialize(this);
            _uiController.SetFpsLabelPathToHud("FPSText");
            _uiController.SetLabelPathToHud("PositionText");

            _roleManager = new();
            AddChild(_roleManager);

            _remotePlayerManager = new();
            AddChild(_remotePlayerManager);

            _chunkManagerCpp = GetNode<Node3D>("ChunkManager");

            await _playerHandler.SpawnPlayerAsync();
            _playerHandler.SetupHungerSignal(_playerStatusSyncHandler);

            await GameInitializer.InitializeAsync(
                this,
                _connection,
                _roleManager,
                _remotePlayerManager,
                _opponentScene,
                _chunkManagerCpp,
                _uiController,
                _playerSpawner,
                _playerManager
            );

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

            ItemData witchMagicSkill = ItemDatabase.Instance.GetItem("witch_magic_skill");
            witchMagicSkill.OnUseAction = async (user) => await _witchMagic.UseSkill(user);

            _ = _bgmManager?.PlayBgm(0.0f, BGMList);

            PlayerManager.GrantInitialItems(_hotbarManager, GrantItemDic);
            
            List<string> myHaveSkills = RoleInfo.RoleSkillIds[_roleManager?.MyRole ?? 0];
            ushort myHaveSkillsCount = (ushort)myHaveSkills.Count;
            for (ushort i = 0; i < myHaveSkillsCount; i++)
            {
                GrantSkillItems.GrantInitialSkillItems(_hotbarManager, myHaveSkills[i]);
            }

            if (_uiController != null)
            {
                await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, 5000);
                PlayerSpawner.SetPlayerPhysicsEnabled(_playerHandler.MyPlayerInstance, true);
            }
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed("ui_cancel"))
            {
                GD.Print("🔑 [MainGameScene] _UnhandledInput で ESCキー（ui_cancel）を検知しました。ゲームメニューをトグルします。");
                ToggleGameMenu();
                GetViewport().SetInputAsHandled();
            }
        }

        public override void _Input(InputEvent @event)
        {
            bool isMenuOpen = _activeMenuInstance != null && IsInstanceValid(_activeMenuInstance) && _activeMenuInstance.Visible;
            if (isMenuOpen)
            {
                return;
            }

            _combatHandler?.HandleInput(@event);
        }

        private void ToggleGameMenu()
        {
            bool isOpen = _activeMenuInstance != null && IsInstanceValid(_activeMenuInstance);
            GD.Print($"🔄 [MainGameScene] ToggleGameMenu 呼び出し. 現在のメニュー状態: {isOpen}");
            if (isOpen)
            {
                CloseGameMenu();
            }
            else
            {
                OpenGameMenu();
            }
        }

        private void OpenGameMenu()
        {
            GD.Print("📂 [MainGameScene] OpenGameMenu 実行開始...");
            if (_activeMenuInstance == null && _menuScene != null)
            {
                LobbyMenu.isLobby = false;
                _activeMenuInstance = _menuScene.Instantiate<Control>();
                
                CanvasLayer canvasLayer = GetNodeOrNull<CanvasLayer>("MenuCanvasLayer");
                if (canvasLayer == null)
                {
                    canvasLayer = new()
                    {
                        Name = "MenuCanvasLayer"
                    };
                    AddChild(canvasLayer);
                }
                canvasLayer.AddChild(_activeMenuInstance);

                if (_activeMenuInstance is LobbyMenu menu)
                {
                    menu.ResumeRequested += CloseGameMenu;
                    menu.InitMenuForGame();
                }
            }
            else if (_activeMenuInstance == null && _menuScene == null)
            {
                GD.PrintErr("❌ [MainGameScene] _menuScene (Menu_2.tscn) のロードに失敗しています！パスを確認してください。");
            }

            if (_activeMenuInstance != null)
            {
                _activeMenuInstance.Visible = true;
                Input.MouseMode = Input.MouseModeEnum.Visible;
                if (_playerHandler?.MyPlayerInstance != null)
                {
                    _playerHandler.MyPlayerInstance.Call("set_movement_enabled", false);
                }
                GD.Print("✅ [MainGameScene] ゲームメニューを表示しました。");
            }
        }

        private void CloseGameMenu()
        {
            GD.Print("📁 [MainGameScene] CloseGameMenu 実行。メニューを破棄します。");
            if (_activeMenuInstance != null && IsInstanceValid(_activeMenuInstance))
            {
                _activeMenuInstance.QueueFree();
            }
            _activeMenuInstance = null;

            Input.MouseMode = Input.MouseModeEnum.Captured;
            if (_playerHandler?.MyPlayerInstance != null)
            {
                _playerHandler.MyPlayerInstance.Call("set_movement_enabled", true);
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

            _ = _uiHandler?.UpdateCoordsUI();
            _ = _uiHandler?.UpdateHpUIFromPlayer();
            _ = _uiHandler?.UpdateHungerUIFromPlayer();

            _playerTransformSyncHandler?.ProcessMovementSync();
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
            _playerManager?.RemovePlayerManager();

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