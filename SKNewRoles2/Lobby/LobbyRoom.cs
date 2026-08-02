using Godot;
using System.Collections.Generic;
using SKNewRoles2.SessionManagerSystem;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;

namespace SKNewRoles2.Lobby
{
    public partial class LobbyRoom : Node3D
    {
        internal Label RoomInfoLabel;
        internal Button LeaveButton;
        internal Button PrivacyToggleButton;
        internal Button StartGameButton;

        internal Dictionary<string, Node3D> _otherPlayers = [];

        private PackedScene _playerPrefab;
        private PackedScene _dummyPlayerPrefab;
        private Node3D _myPlayerInstance;
        private RoomUI _roomUIInstance;

        private bool _isTransitioning = false;
        private float _broadcastTimer = 0.0f;

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
                LeaveButton.Pressed += async () => await LobbyNavigation.LeaveLobbyAsync(GetTree(), LeaveButton, CleanupEvents);
            }

            if (PrivacyToggleButton != null)
            {
                PrivacyToggleButton.Pressed += _roomUIInstance.OnPrivacyToggleButtonPressed;
                PrivacyToggleButton.Disabled = !SessionManager.Instance.IsHost;
            }

            if (StartGameButton != null)
            {
                StartGameButton.Pressed += _roomUIInstance.OnStartGameButtonPressed;
                StartGameButton.Disabled = !SessionManager.Instance.IsHost;
            }

            // ネットワークイベント登録
            LobbyRealtimeHelper.RegisterListeners(OnRoomSettingsChangedFromServer, OnRemotePlayerTransformReceived);

            _roomUIInstance.UpdateRoomInfoUI();
            _roomUIInstance.UpdatePrivacyButtonVisual(SessionManager.Instance.IsPublic);

            // プレハブのロード
            if (ResourceLoader.Exists("res://Scenes/Prefabs/Player.tscn"))
            {
                _playerPrefab = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");
            }

            _dummyPlayerPrefab = ResourceLoader.Exists("res://Scenes/Prefabs/LobbyPlayerDummy.tscn")
                ? GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn")
                : _playerPrefab;

            // マテリアルの Triplanar 自動適用
            LobbyMeshUtility.ApplyTriplanarToAllMeshes(this);

            await SpawnPlayerPrefab();
        }

        public override void _Process(double delta)
        {
            RealtimeBroadcastService.PollRealtimeEvents();

            // プレイヤー座標の定期送信
            LobbyRealtimeHelper.UpdatePlayerTransformBroadcast(_myPlayerInstance, ref _broadcastTimer, (float)delta);
        }

        private void OnRoomSettingsChangedFromServer()
        {
            if (_isTransitioning || !IsInstanceValid(this) || !IsInsideTree()) return;
            _roomUIInstance.OnRoomSettingsChangedFromServer();
        }

        public void LeaveLobbyForced()
        {
            LobbyNavigation.LeaveLobbyCleanup(GetTree(), CleanupEvents);
        }

        public void TransitionToGameStage()
        {
            if (_isTransitioning || !IsInstanceValid(this) || !IsInsideTree()) return;
            _isTransitioning = true;

            LobbyNavigation.TransitionToGameStage(GetTree(), _otherPlayers.Keys, CleanupEvents);
        }

        private void CleanupEvents()
        {
            LobbyRealtimeHelper.UnregisterListeners(OnRoomSettingsChangedFromServer, OnRemotePlayerTransformReceived);
            _otherPlayers.Clear();
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