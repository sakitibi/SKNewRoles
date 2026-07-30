using Godot;
using System.Threading.Tasks;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Game.Network;

namespace SKNewRoles2.Game
{
    public partial class MainGameScene : Node3D
    {
        private Node3D _chunkManagerCpp;

        private PackedScene _playerScene = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");
        private PackedScene _opponentScene = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");

        private Node3D _myPlayerInstance;
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        private readonly RealtimeConnection _connection = new();

        public int MyRole => _roleManager?.MyRole ?? -1;
        public int MyFaction => _roleManager?.MyFaction ?? -1;

        public override async void _Ready()
        {
            GD.Print("1️⃣ [_Ready] 開始");

            _bgmManager = new BGMManager();
            AddChild(_bgmManager);
            _bgmManager.PlayRandomBgm(0.0f);

            // サブマネージャーの生成と初期化
            _uiController = new GameUIController();
            AddChild(_uiController);
            _uiController.Initialize(this);

            _roleManager = new GameRoleManager();
            AddChild(_roleManager);
            _roleManager.Initialize(GetNodeOrNull<Node>("RoleManager"));

            _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

            // リモートプレイヤーマネージャーの登録
            _remotePlayerManager = new RemotePlayerManager();
            AddChild(_remotePlayerManager);

            // サブマネージャーの生成と初期化
            _uiController = new GameUIController();
            AddChild(_uiController);
            _uiController.Initialize(this);

            _roleManager = new GameRoleManager();
            AddChild(_roleManager);
            _roleManager.Initialize(GetNodeOrNull<Node>("RoleManager"));

            _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

            // リモートプレイヤーマネージャーの登録
            _remotePlayerManager = new RemotePlayerManager();
            AddChild(_remotePlayerManager);
            _remotePlayerManager.Initialize(_opponentScene, GetMyUserId());

            // 自分のプレイヤーを生成
            if (_myPlayerInstance == null)
            {
                SpawnMyPlayer();
                SetPlayerPhysicsEnabled(false);
            }

            GD.Print("2️⃣ [_Ready] チャンク読み込み待機開始");
            await WaitForInitialChunksLoaded();

            if (SessionManager.Instance != null && SessionManager.Instance.IsHost)
            {
                GD.Print("3️⃣ [_Ready] ホストとして役職割り当てを実行");
                _roleManager.AssignRolesToAllPlayers(GetMyUserId());
            }

            GD.Print("4️⃣ [_Ready] 役職受諾のループ待機開始");
            bool received = await _roleManager.WaitForRoleAssignedAsync(timeoutMs: 10000);

            if (!received)
            {
                GD.PrintErr("⚠️ 役職受信タイムアウトのため、デフォルト(村人)を適用します");
                _roleManager.ApplyRole(0, 0);
            }

            GD.Print("5️⃣ [_Ready] 役職データ確認完了");
            GD.Print("6️⃣ [_Ready] ロード画面を非表示にして役職画面を表示します");

            _uiController.HideLoadingScene();
            await _uiController.ShowRoleRevealAsync(_roleManager.MyRole, _roleManager.MyFaction, displayTimeMs: 5000);

            SetPlayerPhysicsEnabled(true);
        }

        private async Task WaitForInitialChunksLoaded()
        {
            if (_chunkManagerCpp == null) return;

            int timeoutCounter = 0;
            while (timeoutCounter < 150)
            {
                bool isComplete = false;
                if (_chunkManagerCpp.HasMethod("is_initial_load_complete"))
                {
                    isComplete = (bool)_chunkManagerCpp.Call("is_initial_load_complete");
                }

                if (isComplete)
                {
                    GD.Print("✅ 初期チャンク読み込み完了");
                    return;
                }

                await Task.Delay(100);
                timeoutCounter++;
            }

            GD.PrintErr("⚠️ チャンク読み込み待機がタイムアウト(15秒)しました。強制続行します。");
        }

        public override void _Process(double delta)
        {
            _connection.Poll();
            SendMyTransform();
        }

        private void SpawnMyPlayer()
        {
            if (_playerScene == null) return;

            _myPlayerInstance = _playerScene.Instantiate<Node3D>();
            _myPlayerInstance.Name = "MyPlayer";
            _myPlayerInstance.AddToGroup("LocalPlayer");

            AddChild(_myPlayerInstance);

            _myPlayerInstance.GlobalPosition = new Vector3(0, 100, 0);

            _myPlayerInstance.Connect("hp_changed", Callable.From<int, int>(OnMyPlayerHpChanged));

            if (_myPlayerInstance.HasMethod("get_current_hp") && _myPlayerInstance.HasMethod("get_max_hp"))
            {
                int curHp = (int)_myPlayerInstance.Call("get_current_hp");
                int maxHp = (int)_myPlayerInstance.Call("get_max_hp");
                OnMyPlayerHpChanged(curHp, maxHp);
            }

            _chunkManagerCpp?.Set("player_path", _myPlayerInstance.GetPath());
        }

        private void SetPlayerPhysicsEnabled(bool enabled)
        {
            if (_myPlayerInstance == null) return;

            if (_myPlayerInstance is CharacterBody3D body)
            {
                body.Velocity = Vector3.Zero;
            }

            if (_myPlayerInstance.HasMethod("set_movement_enabled"))
            {
                _myPlayerInstance.Call("set_movement_enabled", enabled);
            }
        }

        private static string GetMyUserId()
        {
            string myUserId = SessionManager.Instance?.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myUserId))
            {
                myUserId = $"Guest_{SessionManager.Instance?.CurrentRoomCode ?? "SingleTest"}";
            }
            return myUserId;
        }

        private void SendMyTransform()
        {
            if (_myPlayerInstance == null) return;

            Vector3 pos = _myPlayerInstance.GlobalPosition;
            Vector3 rot = _myPlayerInstance.Rotation;

            RealtimeBroadcaster.SendTransform(_connection, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
        }

        private void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            _uiController?.UpdateHp(currentHp, maxHp);

            string myUserId = GetMyUserId();
            RealtimeBroadcaster.SendHp(_connection, myUserId, currentHp, maxHp);
        }
    }
}