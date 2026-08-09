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

        private Label _pingLabel;
        private float _pingUpdateTimer = 0.0f;

        public int MyRole => _roleManager?.MyRole ?? -1;
        public int MyFaction => _roleManager?.MyFaction ?? -1;

        public override async void _Ready()
        {
            GD.Print("[_Ready] 開始");

            _pingLabel = GetNodeOrNull<Label>("UILayer/PingLabel");

            _bgmManager = new BGMManager();
            AddChild(_bgmManager);

            // UIの初期化
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
                // ネットワーク接続
                bool isConnected = await _connection.EnsureConnectedAsync();
                if (!isConnected)
                {
                    GD.PrintErr("❌ [Realtime] MainGameScene での WebSocket 接続に失敗しました。");
                }

                _roleManager = new GameRoleManager();
                AddChild(_roleManager);
                _roleManager.Initialize(GetNodeOrNull<Node>("RoleManager"));

                _chunkManagerCpp = GetNodeOrNull<Node3D>("ChunkManager");

                _remotePlayerManager = new RemotePlayerManager();
                AddChild(_remotePlayerManager);
                _remotePlayerManager.Initialize(_opponentScene, GetMyUserId());

                await WaitForInitialChunksLoaded();

                // 役職割り当ての待機
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
            catch (System.Exception ex)
            {
                GD.PrintErr($"❌ [_Ready] 初期化待機中にエラーが発生しました: {ex.Message}");
            }
            finally
            {
                _uiController.HideLoadingScene();
            }

            if (_myPlayerInstance != null)
            {
                _myPlayerInstance.Visible = true;
            }

            // BGM再生開始
            _bgmManager.PlayRandomBgm(0.0f);

            await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, displayTimeMs: 5000);

            SetPlayerPhysicsEnabled(true);
        }

        public override void _Process(double delta)
        {
            _connection.Poll();

            // PING表示の更新
            _pingUpdateTimer += (float)delta;
            if (_pingUpdateTimer >= 0.5f)
            {
                _pingUpdateTimer = 0.0f;
                if (_pingLabel != null)
                {
                    int ping = _connection.PingMs;
                    _pingLabel.Text = ping >= 0 ? $"PING: {ping} ms" : "PING: -- ms";
                }
            }

            // プレイヤーが存在する場合、位置と座標UIの更新を行う
            if (_myPlayerInstance != null)
            {
                _uiController?.UpdateCoords(_myPlayerInstance.GlobalPosition);

                if (_myPlayerInstance.Visible)
                {
                    SendMyTransform();
                }
            }
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

            if (_myPlayerInstance.HasSignal("HpChanged"))
            {
                _myPlayerInstance.Connect("HpChanged", Callable.From<int, int>(OnMyPlayerHpChanged));
            }

            // --- 初期HPの設定 ---
            int currentHp = 20;
            int maxHp = 20;

            var maxHpVar = _myPlayerInstance.Get("MaxHp");
            var curHpVar = _myPlayerInstance.Get("CurrentHp");

            if (maxHpVar.VariantType == Variant.Type.Int)
            {
                maxHp = (int)maxHpVar;
            }
            if (curHpVar.VariantType == Variant.Type.Int)
            {
                currentHp = (int)curHpVar;
            }

            _uiController?.UpdateHp(currentHp, maxHp);

            GD.Print($"👤 [MainGameScene] 自プレイヤーを生成しました。(HP: {currentHp}/{maxHp}, Pos: {spawnPos})");
        }

        private void SetPlayerPhysicsEnabled(bool enabled)
        {
            if (_myPlayerInstance == null) return;

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

            _ = RealtimeBroadcaster.SendTransformAsync(_connection, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
        }

        private void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            _uiController?.UpdateHp(currentHp, maxHp);
            _remotePlayerManager?.SetMyHp(currentHp);

            string myUserId = GetMyUserId();
            _ = RealtimeBroadcaster.SendHpAsync(_connection, myUserId, currentHp, maxHp);
        }

        public override void _ExitTree()
        {
            GD.Print("🚪 [MainGameScene] _ExitTree: シーン破棄のためBGMを停止します。");
            _bgmManager?.StopBgm();
            _connection?.Close();

            base._ExitTree();
        }

        public void StopBGM()
        {
            _bgmManager?.StopBgm();
        }
    }
}