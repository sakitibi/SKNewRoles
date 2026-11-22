using Godot;
using System.Collections.Generic;
using System.Threading.Tasks;
using SKNewRoles2.Lobby.JOIN.Services.Realtime;
using SKNewRoles2.Lobby.UI;
using SKNewRoles2.Game.BGM;

namespace SKNewRoles2.Lobby
{
	public partial class LobbyRoom : Node3D
	{
		internal Label RoomInfoLabel;
		
		[Export] private PackedScene _lobbyMenuScene;

		internal Dictionary<string, Node3D> _otherPlayers = [];
		private readonly Dictionary<string, Dictionary<string, string>> _remotePlayerSkins = [];

		public PackedScene playerPrefab;
		private PackedScene _dummyPlayerPrefab;
		private LobbyMyPlayerManager _myPlayerManager;
		private LobbyRemotePlayerManager _remotePlayerManager;
		private LobbyPlayerSkinSyncHandler _skinSyncHandler;
		private LobbyMenuManager _menuManager;

		private RoomUI _roomUIInstance;
		internal bool _isTransitioning = false;
		private readonly BGMManager _bgmManager = new();

		public Color GrassBlockColor { get; set; } = new Color(0.3f, 0.85f, 0.15f, 1.0f);

		public override async void _Ready()
		{
			GD.Print("🏠 [LobbyRoom] LobbyRoom が _Ready になりました。");
			RoomInfoLabel = GetNodeOrNull<Label>("%RoomInfoLabel");
			_roomUIInstance = new(this);
			_menuManager = new(this, _lobbyMenuScene);

			if (ResourceLoader.Exists("res://Scenes/Prefabs/Player.tscn"))
			{
				playerPrefab = GD.Load<PackedScene>("res://Scenes/Prefabs/Player.tscn");
			}

			_dummyPlayerPrefab = ResourceLoader.Exists("res://Scenes/Prefabs/LobbyPlayerDummy.tscn")
				? GD.Load<PackedScene>("res://Scenes/Prefabs/LobbyPlayerDummy.tscn")
				: playerPrefab;

			_myPlayerManager = new LobbyMyPlayerManager(this, playerPrefab);
			_remotePlayerManager = new LobbyRemotePlayerManager(this, _dummyPlayerPrefab, _otherPlayers);
			_skinSyncHandler = new LobbyPlayerSkinSyncHandler(_remotePlayerSkins, _otherPlayers);

			RealtimeEvents.OnGameStartReceived += HandleGameStartReceived;
			RealtimeEvents.OnPlayerLeaveReceived += OnRemotePlayerLeaveReceived;
			RealtimeEvents.OnPlayerSkinReceived += _skinSyncHandler.OnRemotePlayerSkinReceived;

			await LobbyRealtimeHelper.RegisterListeners(OnRoomSettingsChangedFromServer, OnRemotePlayerTransformReceived);

			_roomUIInstance.UpdateRoomInfoUI();
			LobbyMeshUtility.ApplyTriplanarToAllMeshes(this);

			await _myPlayerManager.SpawnAndSetupPlayerAsync(GrassBlockColor);
			_bgmManager?.StopBgm();
		}

		public override void _UnhandledInput(InputEvent @event)
		{
			if (@event.IsActionPressed("ui_cancel"))
			{
				GD.Print("🔑 [LobbyRoom] ESCキー（ui_cancel）を検出しました。ToggleMenuを呼び出します。");
				_menuManager.ToggleMenu(_roomUIInstance);
				GetViewport().SetInputAsHandled();
			}
		}

		private void HandleGameStartReceived()
		{
			_ = TriggerCountdownAndTransition();
		}

		public async Task TriggerCountdownAndTransition()
		{
			if (_isTransitioning || !IsInstanceValid(this) || !IsInsideTree()) return;
			_isTransitioning = true;

			_menuManager.DestroyMenu();

			await LobbyCountdownManager.StartCountdownAndTransitionAsync(
				this, 
				null,
				null, 
				_otherPlayers.Keys, 
				CleanupEvents
			);
		}

		private void OnRoomSettingsChangedFromServer()
		{
			if (_isTransitioning || !IsInstanceValid(this) || !IsInsideTree()) return;
			_roomUIInstance.OnRoomSettingsChangedFromServer();
		}

		private void OnRemotePlayerTransformReceived(string playerId, float px, float py, float pz, float rx, float ry, float rz)
		{
			_remotePlayerManager.HandleTransformReceived(
				playerId, px, py, pz, rx, ry, rz, 
				async (id, x, y, z, rxVal, ryVal, rzVal) =>
				{
					await _remotePlayerManager.SpawnRemotePlayerAsync(
						id, x, y, z, rxVal, ryVal, rzVal, 
						_remotePlayerSkins, 
						_myPlayerManager?.MyPlayerInstance
					);
					_ = LobbyPlayerSkinSyncHandler.SendMySkinResyncAsync(_myPlayerManager?.MyPlayerInstance);
				}
			);
		}

		private void OnRemotePlayerLeaveReceived(string playerId)
		{
			if (_otherPlayers.TryGetValue(playerId, out Node3D playerNode))
			{
				if (IsInstanceValid(playerNode))
				{
					playerNode.QueueFree();
				}
				_otherPlayers.Remove(playerId);
			}
		}

		public void LeaveLobbyForced()
		{
			RealtimeLobbySender.LobbySendLeave();
			LobbyNavigation.LeaveLobbyCleanup(GetTree(), CleanupEvents);
		}

		public void CleanupEventsPublic() => CleanupEvents();

		private async void CleanupEvents()
		{
			RealtimeEvents.OnGameStartReceived -= HandleGameStartReceived;
			RealtimeEvents.OnPlayerLeaveReceived -= OnRemotePlayerLeaveReceived;
			
			if (_skinSyncHandler != null)
			{
				RealtimeEvents.OnPlayerSkinReceived -= _skinSyncHandler.OnRemotePlayerSkinReceived;
			}

			await LobbyRealtimeHelper.UnregisterListeners(OnRoomSettingsChangedFromServer, OnRemotePlayerTransformReceived);
			_otherPlayers.Clear();
			_remotePlayerSkins.Clear();
		}

		public override void _ExitTree()
		{
			try
			{
				RealtimeLobbySender.LobbySendLeave();
			}
			catch {}
			CleanupEvents();
			base._ExitTree();
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
