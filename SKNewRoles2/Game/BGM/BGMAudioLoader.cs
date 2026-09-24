using Godot;

namespace SKNewRoles2.Game.BGM
{
    public static class BGMAudioLoader
    {
        /// <summary>
        /// 指定パスから AudioStream を読み込む
        /// </summary>
        public static AudioStream LoadAudioStream(string path)
        {
            if (path.StartsWith("res://"))
            {
                return GD.Load<AudioStream>(path);
            }

            if (!FileAccess.FileExists(path))
            {
                GD.PrintErr($"⚠️ [BGMAudioLoader] ファイルが存在しません: {path}");
                return null;
            }

            using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
            if (file == null)
            {
                GD.PrintErr($"⚠️ [BGMAudioLoader] ファイルを開けませんでした: {path}");
                return null;
            }

            byte[] buffer = file.GetBuffer((long)file.GetLength());

            if (path.EndsWith(".mp3", System.StringComparison.OrdinalIgnoreCase))
            {
                return new AudioStreamMP3 { Data = buffer };
            }

            GD.PrintErr($"⚠️ [BGMAudioLoader] サポートされていない音声形式です: {path}");
            return null;
        }
    }
}