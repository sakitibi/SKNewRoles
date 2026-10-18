using Godot;
using SKNewRoles2.Game.Network;
using SKNewRoles2.Game.Inventory.Item;
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

                UpdateSinglePlayerVisibility(senderId, targetPlayer);
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
                    UpdateSinglePlayerVisibility(senderId, remotePlayer);
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

        private void RefreshRemotePlayerHandItem(string senderId)
        {
            if (!_otherPlayers.TryGetValue(senderId, out Node3D remotePlayer) || !IsInstanceValid(remotePlayer)) return;

            int selectedSlot = _otherPlayerSelectedSlots.TryGetValue(senderId, out int slot) ? slot : 0;
            string activeItemId = "";

            if (_otherPlayerInventories.TryGetValue(senderId, out var inv) && inv.TryGetValue(selectedSlot, out var itemId))
            {
                activeItemId = itemId;
            }

            UpdateRightArmItem(remotePlayer, activeItemId);
        }

        private static void UpdateRightArmItem(Node3D remotePlayer, string itemId)
        {
            var rightArm = remotePlayer.GetNodeOrNull<Node3D>("SkinModel/RightArm");
            if (rightArm == null) return;

            var existingItemNode = rightArm.GetNodeOrNull<Node3D>("HandHeldItem");
            existingItemNode?.QueueFree();

            if (string.IsNullOrEmpty(itemId) || itemId == "none" || itemId == "air")
            {
                return;
            }

            Texture2D iconTexture = null;
            if (ItemDatabase.Instance != null)
            {
                var itemData = ItemDatabase.Instance.GetItem(itemId);
                iconTexture = itemData?.Icon;
            }

            if (iconTexture == null)
            {
                string texturePath = $"res://Resources/Items/{itemId}.png";
                iconTexture = GD.Load<Texture2D>(texturePath);
            }

            if (iconTexture == null)
            {
                return;
            }

            Sprite3D itemSprite = new() {
                Name = "HandHeldItem",
                Texture = iconTexture,
                TextureFilter = BaseMaterial3D.TextureFilterEnum.Nearest,
                PixelSize = 0.025f,
                Centered = true,
                Transform = new Transform3D(Basis.Identity, new Vector3(0.0f, -0.4f, 0.05f))
            };

            rightArm.AddChild(itemSprite);
        }

        private void UpdateAllPlayersVisibility()
        {
            foreach (var kvp in _otherPlayers)
            {
                if (IsInstanceValid(kvp.Value))
                {
                    UpdateSinglePlayerVisibility(kvp.Key, kvp.Value);
                }
            }
        }

        private void UpdateSinglePlayerVisibility(string senderId, Node3D remotePlayer)
        {
            int opponentHp = _otherPlayerHps.TryGetValue(senderId, out int hp) ? hp : 20;

            if (opponentHp >= 1)
            {
                SetPlayerVisualState(remotePlayer, visible: true, isTransparent: false);
            }
            else
            {
                if (_myHp >= 1)
                {
                    SetPlayerVisualState(remotePlayer, visible: false, isTransparent: false);
                }
                else
                {
                    SetPlayerVisualState(remotePlayer, visible: true, isTransparent: true);
                }
            }
        }

        private static void SetPlayerVisualState(Node3D playerNode, bool visible, bool isTransparent)
        {
            playerNode.Visible = visible;
            if (!visible) return;

            SetNodeAlphaRecursive(playerNode, isTransparent ? 0.2f : 1.0f);
        }

        private static void SetNodeAlphaRecursive(Node node, float alpha)
        {
            if (node is GeometryInstance3D geom)
            {
                geom.CastShadow = alpha < 1.0f 
                    ? GeometryInstance3D.ShadowCastingSetting.Off 
                    : GeometryInstance3D.ShadowCastingSetting.On;
            }

            if (node is MeshInstance3D meshInstance)
            {
                int surfaceCount = meshInstance.GetSurfaceOverrideMaterialCount();
                if (surfaceCount == 0 && meshInstance.Mesh != null)
                {
                    surfaceCount = meshInstance.Mesh.GetSurfaceCount();
                }

                for (int i = 0; i < surfaceCount; i++)
                {
                    Material mat = meshInstance.GetSurfaceOverrideMaterial(i) ?? meshInstance.Mesh?.SurfaceGetMaterial(i);
                    
                    if (mat is StandardMaterial3D stdMat)
                    {
                        StandardMaterial3D dupMat = (StandardMaterial3D)stdMat.Duplicate();
                        
                        if (alpha < 1.0f)
                        {
                            dupMat.Transparency = BaseMaterial3D.TransparencyEnum.AlphaDepthPrePass; 
                            dupMat.BlendMode = BaseMaterial3D.BlendModeEnum.Mix;
                        }
                        else
                        {
                            dupMat.Transparency = BaseMaterial3D.TransparencyEnum.Disabled;
                        }

                        Color color = dupMat.AlbedoColor;
                        color.A = alpha;
                        dupMat.AlbedoColor = color;

                        meshInstance.SetSurfaceOverrideMaterial(i, dupMat);
                    }
                }
            }

            foreach (Node child in node.GetChildren())
            {
                SetNodeAlphaRecursive(child, alpha);
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
            }
        }
    }
}