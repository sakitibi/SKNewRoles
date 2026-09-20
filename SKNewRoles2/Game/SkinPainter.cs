using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class SkinPainter : Node3D
    {
        [Export] private Shader _atlasShader;

        private readonly Dictionary<string, Image> _partImages = [];
        private readonly Dictionary<string, ImageTexture> _partTextures = [];
        private readonly Dictionary<string, ShaderMaterial> _partMaterials = [];

        private static readonly Dictionary<string, Vector2I> PartResolutionMap = new()
        {
            { "Head",     new Vector2I(32, 16) },
            { "Body",     new Vector2I(24, 16) },
            { "RightArm", new Vector2I(16, 16) },
            { "LeftArm",  new Vector2I(16, 16) },
            { "RightLeg", new Vector2I(16, 16) },
            { "LeftLeg",  new Vector2I(16, 16) }
        };

        public void Initialize(Node3D targetModel)
        {
            SetupPart(targetModel, "SkinModel/Head");
            SetupPart(targetModel, "SkinModel/Body");
            SetupPart(targetModel, "SkinModel/RightArm");
            SetupPart(targetModel, "SkinModel/LeftArm");
            SetupPart(targetModel, "SkinModel/RightLeg");
            SetupPart(targetModel, "SkinModel/LeftLeg");
        }

        private void SetupPart(Node3D root, string nodePath)
        {
            var meshInstance = root.GetNodeOrNull<MeshInstance3D>(nodePath);
            if (meshInstance == null) return;

            string partName = meshInstance.Name;
            Vector2I res = PartResolutionMap.GetValueOrDefault(partName, new Vector2I(64, 64));

            Image image = Image.CreateEmpty(res.X, res.Y, false, Image.Format.Rgba8);
            image.Fill(Colors.White);

            ImageTexture dynTexture = ImageTexture.CreateFromImage(image);

            ShaderMaterial mat = null;

            if (meshInstance.MaterialOverride is ShaderMaterial overrideMat)
            {
                mat = (ShaderMaterial)overrideMat.Duplicate();
            }
            else if (meshInstance.GetActiveMaterial(0) is ShaderMaterial activeMat)
            {
                mat = (ShaderMaterial)activeMat.Duplicate();
            }
            else if (_atlasShader != null)
            {
                mat = new ShaderMaterial { Shader = _atlasShader };
            }

            if (mat != null)
            {
                mat.SetShaderParameter("texture_albedo", dynTexture);
                meshInstance.MaterialOverride = mat;

                _partImages[partName] = image;
                _partTextures[partName] = dynTexture;
                _partMaterials[partName] = mat;
            }
            else
            {
                GD.PrintErr($"[SkinPainter] {partName} の ShaderMaterial 取得に失敗しました。");
            }
        }

        public bool ApplyPresetToPart(string partName, string resPath)
        {
            if (!_partImages.ContainsKey(partName))
            {
                GD.PrintErr($"[SkinPainter] 未登録の部位です: {partName}");
                return false;
            }

            if (!ResourceLoader.Exists(resPath))
            {
                GD.PrintErr($"[SkinPainter] プリセット画像が見つかりません: {resPath}");
                return false;
            }

            var texture = GD.Load<Texture2D>(resPath);
            if (texture == null)
            {
                GD.PrintErr($"[SkinPainter] テクスチャのロードに失敗しました: {resPath}");
                return false;
            }

            Image loadedImage = texture.GetImage();
            Vector2I targetRes = PartResolutionMap.GetValueOrDefault(partName, new Vector2I(64, 64));
            if (loadedImage.GetWidth() != targetRes.X || loadedImage.GetHeight() != targetRes.Y)
            {
                loadedImage.Resize(targetRes.X, targetRes.Y, Image.Interpolation.Nearest);
            }

            _partImages[partName] = loadedImage;
            _partTextures[partName].Update(loadedImage);

            GD.Print($"[SkinPainter] {partName} にプリセットを適用しました: {resPath}");
            return true;
        }

        /// <summary>
        /// 部位ごとのプリセット設定マップを元に全部位へ適用する
        /// </summary>
        public void ApplyPresetToAllParts(Dictionary<string, string> equippedPresets)
        {
            foreach (var (partName, presetId) in equippedPresets)
            {
                string resPath = $"res://Resources/Skins/{presetId}/{partName.ToLower()}.png";
                ApplyPresetToPart(partName, resPath);
            }
        }
    }
}