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

        /// <summary>
        /// 外部から読み込んだモデルを渡して初期化する
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

            Image image = Image.CreateEmpty(64, 64, false, Image.Format.Rgba8);
            image.Fill(Colors.White);

            ImageTexture dynTexture = ImageTexture.CreateFromImage(image);

            ShaderMaterial mat = new();
            mat.Shader = _atlasShader;
            mat.SetShaderParameter("texture_albedo", dynTexture);

            // インスタンスごとに独立したマテリアルを上書き設定
            meshInstance.MaterialOverride = mat;

            string partName = meshInstance.Name;
            _partImages[partName] = image;
            _partTextures[partName] = dynTexture;
            _partMaterials[partName] = mat;
        }

        public void PaintAt(string partName, Vector2 uv, Color color, int brushSize = 1)
        {
            if (!_partImages.TryGetValue(partName, out var image)) return;

            int width = image.GetWidth();
            int height = image.GetHeight();

            int x = (int)(uv.X * width);
            int y = (int)(uv.Y * height);

            for (int bx = -brushSize + 1; bx < brushSize; bx++)
            {
                for (int by = -brushSize + 1; by < brushSize; by++)
                {
                    int px = Mathf.Clamp(x + bx, 0, width - 1);
                    int py = Mathf.Clamp(y + by, 0, height - 1);
                    image.SetPixel(px, py, color);
                }
            }

            _partTextures[partName].Update(image);
        }

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
    }
}