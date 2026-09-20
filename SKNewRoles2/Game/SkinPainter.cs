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

        /// <summary>
        /// 読み込んだモデルの各部位に個別のマテリアルと初期テクスチャを割り当てる
        /// </summary>
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

            // 部位別サイズの初期画像を作成
            Image image = Image.CreateEmpty(res.X, res.Y, false, Image.Format.Rgba8);
            image.Fill(Colors.White);

            ImageTexture dynTexture = ImageTexture.CreateFromImage(image);

            ShaderMaterial mat = new()
            {
                Shader = _atlasShader
            };
            mat.SetShaderParameter("texture_albedo", dynTexture);

            // インスタンスごとに独立したマテリアルを上書き設定
            meshInstance.MaterialOverride = mat;

            _partImages[partName] = image;
            _partTextures[partName] = dynTexture;
            _partMaterials[partName] = mat;
        }

        /// <summary>
        /// 指定した部位に個別のカスタム画像ファイルを適用する
        /// </summary>
        public bool ApplyCustomImageToPart(string partName, string imagePath)
        {
            if (!_partImages.ContainsKey(partName))
            {
                GD.PrintErr($"[SkinPainter] 未登録の部位です: {partName}");
                return false;
            }

            var loadedImage = Image.LoadFromFile(imagePath);
            if (loadedImage == null)
            {
                GD.PrintErr($"[SkinPainter] 画像の読み込みに失敗しました: {imagePath}");
                return false;
            }

            Vector2I targetRes = PartResolutionMap.GetValueOrDefault(partName, new Vector2I(64, 64));
            if (loadedImage.GetWidth() != targetRes.X || loadedImage.GetHeight() != targetRes.Y)
            {
                loadedImage.Resize(targetRes.X, targetRes.Y, Image.Interpolation.Nearest);
            }

            _partImages[partName] = loadedImage;
            _partTextures[partName].Update(loadedImage);

            GD.Print($"[SkinPainter] {partName} に画像を適用しました ({targetRes.X}x{targetRes.Y}): {imagePath}");
            return true;
        }

        /// <summary>
        /// 指定部位のテクスチャをpng保存
        /// </summary>
        public void SavePartSkin(string partName)
        {
            if (!_partImages.TryGetValue(partName, out var image)) return;

            string dirPath = ProjectSettings.GlobalizePath("user://game_asset/Skins/");
            System.IO.Directory.CreateDirectory(dirPath);

            string filePath = System.IO.Path.Combine(dirPath, $"{partName.ToLower()}_atlas.png");
            Error err = image.SavePng(filePath);

            if (err == Error.Ok)
            {
                GD.Print($"[SkinPainter] 保存成功: {filePath}");
            }
            else
            {
                GD.PrintErr($"[SkinPainter] 保存失敗: {err}");
            }
        }

        /// <summary>
        /// 編集中の全部位スキンを一括保存
        /// </summary>
        public void SaveAllSkins()
        {
            foreach (var partName in _partImages.Keys)
            {
                SavePartSkin(partName);
            }
        }
    }
}