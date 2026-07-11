using Godot;
using System.Collections.Generic;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN;

namespace SKNewRoles2.Lobby
{
    public partial class LobbyRoom : Node3D
    {
        internal Label RoomInfoLabel;
        internal Button LeaveButton;
        internal Button PrivacyToggleButton;
        internal Button StartGameButton;

        // 他のプレイヤーノードを管理する辞書
        internal Dictionary<string, Node3D> _otherPlayers = new();
        
        private PackedScene _playerPrefab;      // 自分の実体用 (Player.tscn)
        private PackedScene _dummyPlayerPrefab; // 他人の見た目同期用 (LobbyPlayerDummy.tscn)

        private Node3D _myPlayerInstance;
        private RoomUI _roomUIInstance;

        // 二重遷移防止・破棄済みアクセス防止用フラグ
        private bool _isTransitioning = false;

        // 位置同期配信用タイマー
        private float _broadcastTimer = 0.0f;
        private const float BroadcastInterval = 0.05f; // 1秒間に20回座標情報を送信

        // ステージの草ブロック（SNR2GrassBlock）の同期カラー
        public Color GrassBlockColor { get; set; } = new Color(0.3f, 0.85f, 0.15f, 1.0f);

        public override async void _Ready()
        {
            RoomInfoLabel = GetNodeOrNull<Label>("%RoomInfoLabel");
            LeaveButton = GetNodeOrNull<Button>("%LeaveButton");
            PrivacyToggleButton = GetNodeOrNull<Button>("%PrivacyToggleButton");
            StartGameButton = GetNodeOrNull<Button>("%StartGameButton");

            _roomUIInstance = new RoomUI(this);

            if (LeaveButton != null)
            {
                LeaveButton.Pressed += LeaveLobbyAsync;
            }

            if (PrivacyToggleButton != null)
            {
                PrivacyToggleButton.Pressed += _roomUIInstance.OnPrivacyToggleButtonPressed;
                bool isHost = SessionManager.Instance.IsHost;
                PrivacyToggleButton.Disabled = !isHost;
            }

            if (StartGameButton != null)
            {
                StartGameButton.Pressed += _roomUIInstance.OnStartGameButtonPressed;
                bool isHost = SessionManager.Instance.IsHost;
                StartGameButton.Disabled = !isHost;
            }

            // イベントの二重登録防止
            LobbyRealtime.OnLobbyTableChanged -= OnRoomSettingsChangedFromServer;
            LobbyRealtime.OnLobbyTableChanged += OnRoomSettingsChangedFromServer;
            
            LobbyRealtime.OnPlayerTransformReceivedAll -= OnRemotePlayerTransformReceived;
            LobbyRealtime.OnPlayerTransformReceivedAll += OnRemotePlayerTransformReceived;

            LobbyRealtime.StartListeningLobbyChanges();

            _roomUIInstance.UpdateRoomInfoUI();
            _roomUIInstance.UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);

            // 自分の操作キャラクター用プレハブをロード
            if (ResourceLoader.Exists("res://Scenes/Prefabs/Player.tscn"))
            {
                _playerPrefab = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");
            }

            // 見た目同期用プレハブをロード
            if (ResourceLoader.Exists("res://Scenes/Prefabs/LobbyPlayerDummy.tscn"))
            {
                _dummyPlayerPrefab = GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn");
            }
            else
            {
                _dummyPlayerPrefab = _playerPrefab;
            }

            await SpawnPlayerPrefab();
        }

        public override void _Process(double delta)
        {
            LobbyRealtime.PollRealtimeEvents();

            if (_myPlayerInstance != null && IsInstanceValid(_myPlayerInstance))
            {
                _broadcastTimer += (float)delta;
                if (_broadcastTimer >= BroadcastInterval)
                {
                    _broadcastTimer = 0.0f;
                    
                    LobbyRealtime.LobbySendTransformBroadcastAll(
                        _myPlayerInstance.Position.X, 
                        _myPlayerInstance.Position.Y, 
                        _myPlayerInstance.Position.Z,
                        _myPlayerInstance.Rotation.X,
                        _myPlayerInstance.Rotation.Y,
                        _myPlayerInstance.Rotation.Z
                    );
                }
            }
        }

        private void OnRoomSettingsChangedFromServer()
        {
            // 既に破棄または遷移中なら実行しない
            if (_isTransitioning || !IsInstanceValid(this) || !IsInsideTree()) return;
            _roomUIInstance.OnRoomSettingsChangedFromServer();
        }

        public async void LeaveLobbyAsync()
        {
            if (IsInstanceValid(LeaveButton))
            {
                LeaveButton.Disabled = true;
            }

            if (SessionManager.Instance.IsHost)
            {
                GD.Print("👑 ホストが退出したため、ロビーを解散します...");
                await LobbySettings.CloseLobbyAsync(SessionManager.Instance.CurrentRoomCode);
            }

            LeaveLobbyCleanup();
        }

        public void LeaveLobbyForced()
        {
            LeaveLobbyCleanup();
        }

        public void LeaveLobbyCleanup()
        {
            CleanupEvents();

            SessionManager.Instance.CurrentRoomCode = "";
            SessionManager.Instance.CurrentRoomName = "";
            SessionManager.Instance.IsHost = false;

            _otherPlayers.Clear();
            GetTree().ChangeSceneToFile("res://Scenes/Lobby_select.tscn");
        }

        /// <summary>
        /// メインゲームステージ（MainGameScene.tscn）へ安全に遷移します
        /// </summary>
        public void TransitionToGameStage()
        {
            if (_isTransitioning || !IsInstanceValid(this) || !IsInsideTree())
            {
                return;
            }
            _isTransitioning = true;

            // 参加者全員の ID を集計して SessionManager に保存
            SessionManager.Instance.CurrentRoomPlayerIds.Clear();

            // 1. 自分の ID
            string myId = SessionManager.Instance.CurrentSession?.User?.Id;
            if (string.IsNullOrEmpty(myId))
            {
                myId = $"Guest_{SessionManager.Instance.CurrentRoomCode}";
            }
            SessionManager.Instance.CurrentRoomPlayerIds.Add(myId);

            // 2. 他プレイヤー (_otherPlayers) の ID
            foreach (string remoteId in _otherPlayers.Keys)
            {
                if (!SessionManager.Instance.CurrentRoomPlayerIds.Contains(remoteId))
                {
                    SessionManager.Instance.CurrentRoomPlayerIds.Add(remoteId);
                }
            }

            GD.Print($"🎮 メインステージへ安全に遷移します。参加者数: {SessionManager.Instance.CurrentRoomPlayerIds.Count} 人");

            // イベントを全解除
            CleanupEvents();
            _otherPlayers.Clear();

            // MainGameScene へ移動
            GetTree().ChangeSceneToFile("res://Scenes/Gamemaps/MainGameScene.tscn");
        }

        private void CleanupEvents()
        {
            LobbyRealtime.OnLobbyTableChanged -= OnRoomSettingsChangedFromServer;
            LobbyRealtime.OnPlayerTransformReceivedAll -= OnRemotePlayerTransformReceived;
            LobbyRealtime.StopListeningLobbyChanges();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                CleanupEvents();
            }
            base.Dispose(disposing);
        }
    }
}