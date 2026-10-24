using Godot;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Lobby;
using System.Collections.Generic;

namespace SKNewRoles2.Game.Player
{
    public partial class RemotePlayerManager : Node
    {
        private PackedScene _opponentScene;
        private RealtimeConnection _connection;
        private readonly Dictionary<string, Node3D> _otherPlayers = [];
        private readonly Dictionary<string, int> _otherPlayerHps = [];
        private readonly Dictionary<string, Dictionary<int, string>> _otherPlayerInventories = [];
        private readonly Dictionary<string, int> _otherPlayerSelectedSlots = [];
        private readonly Dictionary<string, Dictionary<string, string>> _otherPlayerSkins = [];

        private string _myUserId;
        private int _myHp = 20;

        public void Initialize(PackedScene opponentScene, string myUserId, RealtimeConnection connection)
        {
            _opponentScene = opponentScene;
            _myUserId = myUserId;
            _connection = connection;

            if (_connection != null)
            {
                _connection.OnTransformReceived += OnPlayerTransformReceivedAll;
                _connection.OnHpReceived += OnOtherPlayerHpReceived;
                _connection.OnHotbarSlotReceived += OnOtherPlayerHotbarSlotReceived;
                _connection.OnHotbarItemReceived += OnOtherPlayerHotbarItemReceived;
                _connection.OnSkinReceived += OnOtherPlayerSkinReceived;
            }
        }

        public void SetMyHp(int hp)
        {
            _myHp = hp;
            UpdateAllPlayersVisibility();
        }

        private void OnPlayerTransformReceivedAll(string senderId, float px, float py, float pz, float rx, float ry, float rz)
        {
            if (senderId == _myUserId) return;

            if (!_otherPlayers.TryGetValue(senderId, out Node3D targetPlayer))
            {
                if (_opponentScene == null) return;

                targetPlayer = _opponentScene.Instantiate<Node3D>();
                targetPlayer.Name = $"RemotePlayer_{senderId}";
                targetPlayer.SetMeta("player_id", senderId);

                AddChild(targetPlayer);
                
                _otherPlayers[senderId] = targetPlayer;
                _otherPlayerHps[senderId] = 20;
                _otherPlayerSelectedSlots[senderId] = 0;

                RemotePlayerVisualHandler.UpdateVisibility(targetPlayer, 20, _myHp);
                RefreshRemotePlayerHandItem(senderId);

                if (_otherPlayerSkins.TryGetValue(senderId, out var skinPresets))
                {
                    LobbySkinManager.ApplySkinPresets(targetPlayer, skinPresets);
                }
            }

            if (targetPlayer != null)
            {
                if (targetPlayer.HasMethod("set_target_transform"))
                {
                    targetPlayer.Call("set_target_transform", px, py, pz, rx, ry, rz);
                }
                else
                {
                    targetPlayer.GlobalPosition = new Vector3(px, py, pz);
                    targetPlayer.Rotation = new Vector3(rx, ry, rz);
                }
            }
        }

        private void OnOtherPlayerHpReceived(string senderId, int currentHp, int maxHp)
        {
            if (senderId == _myUserId) return;

            _otherPlayerHps[senderId] = currentHp;

            if (_otherPlayers.TryGetValue(senderId, out Node3D remotePlayer))
            {
                if (IsInstanceValid(remotePlayer))
                {
                    if (remotePlayer.HasMethod("set_current_hp"))
                    {
                        remotePlayer.Call("set_current_hp", currentHp);
                    }
                    RemotePlayerVisualHandler.UpdateVisibility(remotePlayer, currentHp, _myHp);
                }
            }
        }

        private void OnOtherPlayerHotbarSlotReceived(string senderId, int slotIndex)
        {
            if (senderId == _myUserId) return;

            _otherPlayerSelectedSlots[senderId] = slotIndex;
            RefreshRemotePlayerHandItem(senderId);
        }

        private void OnOtherPlayerHotbarItemReceived(string senderId, int slotIndex, string itemId, int count)
        {
            if (senderId == _myUserId) return;

            if (!_otherPlayerInventories.TryGetValue(senderId, out var inv))
            {
                inv = [];
                _otherPlayerInventories[senderId] = inv;
            }

            inv[slotIndex] = itemId;
            RefreshRemotePlayerHandItem(senderId);
        }

        /// <summary>
        /// 他プレイヤーからスキン情報を受信した際の処理
        /// </summary>
        private void OnOtherPlayerSkinReceived(string senderId, Dictionary<string, string> skinPresets)
        {
            if (senderId == _myUserId) return;

            // キャッシュに保存
            _otherPlayerSkins[senderId] = skinPresets;

            // すでにプレイヤーインスタンスが存在していれば、すぐにスキンを適用
            if (_otherPlayers.TryGetValue(senderId, out Node3D remotePlayer) && IsInstanceValid(remotePlayer))
            {
                LobbySkinManager.ApplySkinPresets(remotePlayer, skinPresets);
                GD.Print($"🎨 [RemotePlayerManager] リモートプレイヤー ({senderId}) のスキンを更新しました。");
            }
        }

        private void RefreshRemotePlayerHandItem(string senderId)
        {
            if (!_otherPlayers.TryGetValue(senderId, out Node3D remotePlayer) || !IsInstanceValid(remotePlayer)) return;

            int selectedSlot = _otherPlayerSelectedSlots.TryGetValue(senderId, out int slot) ? slot : 0;
            string activeItemId = "";

            if (_otherPlayerInventories.TryGetValue(senderId, out var inv) && inv.TryGetValue(selectedSlot, out var itemId))
            {
                activeItemId = itemId;
            }

            RemotePlayerVisualHandler.UpdateRightArmItem(remotePlayer, activeItemId);
        }

        private void UpdateAllPlayersVisibility()
        {
            foreach (var kvp in _otherPlayers)
            {
                if (IsInstanceValid(kvp.Value))
                {
                    int opponentHp = _otherPlayerHps.TryGetValue(kvp.Key, out int hp) ? hp : 20;
                    RemotePlayerVisualHandler.UpdateVisibility(kvp.Value, opponentHp, _myHp);
                }
            }
        }

        public override void _ExitTree()
        {
            if (_connection != null)
            {
                _connection.OnTransformReceived -= OnPlayerTransformReceivedAll;
                _connection.OnHpReceived -= OnOtherPlayerHpReceived;
                _connection.OnHotbarSlotReceived -= OnOtherPlayerHotbarSlotReceived;
                _connection.OnHotbarItemReceived -= OnOtherPlayerHotbarItemReceived;
                _connection.OnSkinReceived -= OnOtherPlayerSkinReceived;
            }
        }
    }
}