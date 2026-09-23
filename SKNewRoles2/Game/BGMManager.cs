using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class BGMManager : Node
    {
        private AudioStreamPlayer _bgmPlayer;
        private readonly static string BgmPathBases = "user://game_asset/Audio/BGM/";
        public List<string> BgmPaths { get; set; } =
        [
            $"{BgmPathBases}game_bgm1.mp3",
            $"{BgmPathBases}title_bgm1.mp3",
            $"{BgmPathBases}title_bgm2.mp3"
        ];

        /// <summary>
        /// 外部 (MODなど) から新しい BGM パスを追加する
        /// </summary>
        public void AddBgmPath(string path)
        {
            if (!string.IsNullOrEmpty(path) && !BgmPaths.Contains(path))
            {
                BgmPaths.Add(path);
                GD.Print($"🎵 [BGMManager] MOD等からBGMを追加しました: {path}");
            }
        }

        /// <summary>
        /// 外部 (MODなど) から指定した BGM パスを削除する
        /// </summary>
        public void RemoveBgmPath(string path)
        {
            if (BgmPaths.Remove(path))
            {
                GD.Print($"🎵 [BGMManager] BGMを削除しました: {path}");
            }
        }

        /// <summary>
        /// BGMリストをクリアする
        /// </summary>
        public void ClearBgmPaths()
        {
            BgmPaths.Clear();
            GD.Print("🎵 [BGMManager] すべてのBGMパスをクリアしました。");
        }

        /// <summary>
        /// ランダムにBGMを選択して再生を開始する
        /// </summary>
        public void PlayBgm(float volumeDb = 0.0f, int index = -1)
        {
            if (BgmPaths == null || BgmPaths.Count == 0)
            {
                GD.PrintErr("⚠️ [BGMManager] BGMのパスが設定されていません。");
                return;
            }

            int randomIndex;
            if (index == -1 || index >= BgmPaths.Count)
            {
                randomIndex = (int)(GD.Randi() % (uint)BgmPaths.Count);
            }
            else
            {
                randomIndex = index;
            }
            
            string selectedPath = BgmPaths[randomIndex];

            AudioStream stream = LoadAudioStream(selectedPath);
            
            if (stream == null)
            {
                GD.PrintErr($"⚠️ [BGMManager] BGMファイルのロードに失敗しました: {selectedPath}");
                return;
            }

            // MP3のループ設定を有効化
            if (stream is AudioStreamMP3 mp3Stream)
            {
                mp3Stream.Loop = true;
            }

            // プレイヤーの生成・初期化
            if (_bgmPlayer == null)
            {
                _bgmPlayer = new AudioStreamPlayer
                {
                    Name = "BGMPlayer",
                    Bus = "Master"
                };
                AddChild(_bgmPlayer);
            }
            else
            {
                _bgmPlayer.Stop();
            }

            _bgmPlayer.Stream = stream;
            _bgmPlayer.VolumeDb = volumeDb;
            _bgmPlayer.Play();

            GD.Print($"🎵 [BGMManager] BGM再生開始: {selectedPath} (Index: {randomIndex})");
        }

        /// <summary>
        /// パスに応じてリソースをロードする内部ヘルパー
        /// </summary>
        private static AudioStream LoadAudioStream(string path)
        {
            if (path.StartsWith("res://"))
            {
                return GD.Load<AudioStream>(path);
            }

            if (!FileAccess.FileExists(path))
            {
                GD.PrintErr($"⚠️ [BGMManager] ファイルが存在しません: {path}");
                return null;
            }

            using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
            if (file == null)
            {
                GD.PrintErr($"⚠️ [BGMManager] ファイルを開けませんでした: {path}");
                return null;
            }

            byte[] buffer = file.GetBuffer((long)file.GetLength());

            if (path.EndsWith(".mp3", System.StringComparison.OrdinalIgnoreCase))
            {
                AudioStreamMP3 mp3Stream = new()
                {
                    Data = buffer
                };
                return mp3Stream;
            }

            GD.PrintErr($"⚠️ [BGMManager] サポートされていない音声形式です: {path}");
            return null;
        }

        /// <summary>
        /// BGMを停止する
        /// </summary>
        public void StopBgm()
        {
            if (_bgmPlayer != null && _bgmPlayer.Playing)
            {
                _bgmPlayer.Stop();
                GD.Print("🎵 [BGMManager] BGMを停止しました。");
            }
        }

        /// <summary>
        /// 音量を変更する
        /// </summary>
        public void SetVolume(float volumeDb)
        {
            if (_bgmPlayer != null)
            {
                _bgmPlayer.VolumeDb = volumeDb;
            }
        }
    }
}