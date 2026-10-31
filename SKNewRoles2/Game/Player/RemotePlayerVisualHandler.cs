using Godot;
using SKNewRoles2.Game.Inventory.Item;

namespace SKNewRoles2.Game.Player
{
    public static class RemotePlayerVisualHandler
    {
        /// <summary>
        /// 右腕（SkinModel/RightArm）にスプライトを表示・更新する
        /// </summary>
        public static void UpdateRightArmItem(Node3D remotePlayer, string itemId)
        {
            Node3D rightArm = remotePlayer.GetNodeOrNull<Node3D>("SkinModel/RightArm");
            if (rightArm == null) return;

            Node3D existingItemNode = rightArm.GetNodeOrNull<Node3D>("HandHeldItem");
            existingItemNode?.QueueFree();

            if (string.IsNullOrEmpty(itemId) || itemId == "none" || itemId == "air")
            {
                return;
            }

            Texture2D iconTexture = null;
            if (ItemDatabase.Instance != null)
            {
                ItemData itemData = ItemDatabase.Instance.GetItem(itemId);
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
                PixelSize = 0.045f,
                Centered = true,
                Transform = new Transform3D(Basis.Identity, new Vector3(0.0f, -0.45f, 0.12f))
            };

            rightArm.AddChild(itemSprite);
        }

        /// <summary>
        /// HP状態に応じた可視性と透明度の更新
        /// </summary>
        public static void UpdateVisibility(Node3D remotePlayer, int opponentHp, int myHp)
        {
            if (opponentHp >= 1)
            {
                SetPlayerVisualState(remotePlayer, visible: true, isTransparent: false);
            }
            else
            {
                if (myHp >= 1)
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
    }
}