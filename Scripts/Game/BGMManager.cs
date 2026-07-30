using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game
{
    public partial class BGMManager : Node
    {
        private AudioStreamPlayer _bgmPlayer;
        public List<string> BgmPaths { get; set; } =
        [
            "res://Resources/Audio/BGM/game_bgm1.mp3",
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
        public void PlayRandomBgm(float volumeDb = 0.0f)
        {
            if (BgmPaths == null || BgmPaths.Count == 0)
            {
                GD.PrintErr("⚠️ [BGMManager] BGMのパスが設定されていません。");
                return;
            }

            // リストからランダムに1曲選択
            int randomIndex = (int)(GD.Randi() % (uint)BgmPaths.Count);
            string selectedPath = BgmPaths[randomIndex];

            AudioStream stream = GD.Load<AudioStream>(selectedPath);
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