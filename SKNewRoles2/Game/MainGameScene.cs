using Godot;
using System;
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
        private Node _healthComponent;
        private RemotePlayerManager _remotePlayerManager;
        private BGMManager _bgmManager;

        private GameUIController _uiController;
        private GameRoleManager _roleManager;
        private readonly RealtimeConnection _connection = new();
        private int _currentHp = 20;
        private int _maxHp = 20;

        public int MyRole => _roleManager?.MyRole ?? -1;
        public int MyFaction => _roleManager?.MyFaction ?? -1;

        public override async void _Ready()
        {
            GD.Print("[_Ready] 開始");

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
            catch (System.Exception ex)
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

            if (_uiController != null)
            {
                await _uiController.ShowRoleRevealAsync(_roleManager?.MyRole ?? 0, _roleManager?.MyFaction ?? 0, displayTimeMs: 5000);
            }

            SetPlayerPhysicsEnabled(true);
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

                UpdateHpUIFromPlayer();

                if (_myPlayerInstance.Visible)
                {
                    SendMyTransform();
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
                    targetNode.Connect(sig, Callable.From<int, int>(OnMyPlayerHpChanged));
                    break;
                }
            }

            UpdateHpUIFromPlayer();
            GD.Print($"👤 [MainGameScene] 自プレイヤーを生成しました。(Pos: {spawnPos})");
        }

        private void UpdateHpUIFromPlayer()
        {
            if (_myPlayerInstance == null || !IsInstanceValid(_myPlayerInstance) || _uiController == null) return;

            Node targetNode = (_healthComponent != null && IsInstanceValid(_healthComponent)) ? _healthComponent : _myPlayerInstance;

            string[] curHpKeys = ["CurrentHp", "current_hp", "hp", "Health", "health", "CurrentHealth"];
            foreach (var key in curHpKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int hpVal))
                {
                    _currentHp = hpVal;
                    break;
                }
            }

            string[] maxHpKeys = ["MaxHp", "max_hp", "max_health", "MaxHealth"];
            foreach (var key in maxHpKeys)
            {
                var val = targetNode.Get(key);
                if (TryConvertToInt(val, out int maxVal))
                {
                    _maxHp = maxVal;
                    break;
                }
            }

            _uiController.UpdateHp(_currentHp, _maxHp);
        }

        private static bool TryConvertToInt(Variant variant, out int result)
        {
            result = 0;
            if (variant.VariantType == Variant.Type.Nil) return false;

            switch (variant.VariantType)
            {
                case Variant.Type.Int:
                    result = (int)variant;
                    return true;
                case Variant.Type.Float:
                    result = Mathf.RoundToInt((float)variant);
                    return true;
                default:
                    return false;
            }
        }

        private void OnMyPlayerHpChanged(int currentHp, int maxHp)
        {
            _currentHp = currentHp;
            _maxHp = maxHp;

            _uiController?.UpdateHp(currentHp, maxHp);
            _remotePlayerManager?.SetMyHp(currentHp);

            string myUserId = GetMyUserId();
            _ = SafeSendHpAsync(myUserId, currentHp, maxHp);
        }

        private async Task SafeSendHpAsync(string userId, int currentHp, int maxHp)
        {
            try
            {
                await RealtimeBroadcaster.SendHpAsync(_connection, userId, currentHp, maxHp);
            }
            catch (System.Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] HP送信時例外 (送信スキップ): {ex.Message}");
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

        private void SetPlayerPhysicsEnabled(bool enabled)
        {
            if (_myPlayerInstance == null || !IsInstanceValid(_myPlayerInstance)) return;

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
            if (_myPlayerInstance == null || !IsInstanceValid(_myPlayerInstance)) return;

            Vector3 pos = _myPlayerInstance.GlobalPosition;
            Vector3 rot = _myPlayerInstance.Rotation;

            try
            {
                _ = RealtimeBroadcaster.SendTransformAsync(_connection, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z);
            }
            catch (Exception ex)
            {
                GD.PrintErr($"⚠️ [Realtime] Transform送信時例外: {ex.Message}");
            }
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
    }
}