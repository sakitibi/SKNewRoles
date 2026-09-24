using Godot;
using System.Collections.Generic;

namespace SKNewRoles2.Game.BGM
{
    public partial class BGMManager : Node
    {
        private AudioStreamPlayer _bgmPlayer;
        private static readonly string BgmPathBases = "user://game_asset/Audio/BGM/";

        [Export] public float WaitDelaySeconds { get; set; } = 5.0f;

        private float _currentVolumeDb = 0.0f;
        private List<int> _currentCandidateIndices = null;
        private bool _isStopping = false;

        public List<string> BgmPaths { get; set; } =
        [
            $"{BgmPathBases}game_bgm1.mp3",
            $"{BgmPathBases}title_bgm1.mp3",
            $"{BgmPathBases}title_bgm2.mp3",
            $"{BgmPathBases}title_bgm3.mp3"
        ];

        public override void _Ready()
        {
            EnsurePlayerExists();
        }

        private void EnsurePlayerExists()
        {
            if (_bgmPlayer == null)
            {
                _bgmPlayer = new AudioStreamPlayer
                {
                    Name = "BGMPlayer",
                    Bus = "Master"
                };
                
                _bgmPlayer.Finished += OnBgmFinished;
                AddChild(_bgmPlayer);
            }
        }

        private async void OnBgmFinished()
        {
            if (_isStopping) return;

            GD.Print($"🎵 [BGMManager] BGM終了。{WaitDelaySeconds}秒待機してから次の曲を再生します...");

            await ToSignal(GetTree().CreateTimer(WaitDelaySeconds), SceneTreeTimer.SignalName.Timeout);

            if (!_isStopping && IsInsideTree())
            {
                PlayBgm(_currentVolumeDb, index: -1, candidates: _currentCandidateIndices);
            }
        }

        public void AddBgmPath(string path)
        {
            if (!string.IsNullOrEmpty(path) && !BgmPaths.Contains(path))
            {
                BgmPaths.Add(path);
                GD.Print($"🎵 [BGMManager] MOD等からBGMを追加しました: {path}");
            }
        }

        public void RemoveBgmPath(string path)
        {
            if (BgmPaths.Remove(path))
            {
                GD.Print($"🎵 [BGMManager] BGMを削除しました: {path}");
            }
        }

        public void ClearBgmPaths()
        {
            BgmPaths.Clear();
            GD.Print("🎵 [BGMManager] すべてのBGMパスをクリアしました。");
        }

        public void PlayBgm(float volumeDb = 0.0f, int index = -1, List<int> candidates = null)
        {
            _isStopping = false;
            _currentVolumeDb = volumeDb;
            _currentCandidateIndices = candidates;

            int selectedIndex = BGMSelector.SelectIndex(BgmPaths, index, candidates);
            if (selectedIndex < 0)
            {
                GD.PrintErr("⚠️ [BGMManager] 再生可能な BGM パスが存在しないか選曲に失敗しました。");
                return;
            }

            string selectedPath = BgmPaths[selectedIndex];
            AudioStream stream = BGMAudioLoader.LoadAudioStream(selectedPath);

            if (stream == null)
            {
                GD.PrintErr($"⚠️ [BGMManager] BGMファイルのロードに失敗しました: {selectedPath}");
                return;
            }

            if (stream is AudioStreamMP3 mp3Stream)
            {
                mp3Stream.Loop = false;
            }

            EnsurePlayerExists();

            if (!IsInsideTree())
            {
                GD.PrintErr("⚠️ [BGMManager] BGMManager 自身がシーンツリーに追加されていません。");
                return;
            }

            _bgmPlayer.Stop();
            _bgmPlayer.Stream = stream;
            _bgmPlayer.VolumeDb = volumeDb;
            _bgmPlayer.Play();

            GD.Print($"🎵 [BGMManager] BGM再生開始: {selectedPath} (Index: {selectedIndex})");
        }

        public void StopBgm()
        {
            _isStopping = true;
            if (_bgmPlayer != null && _bgmPlayer.Playing)
            {
                _bgmPlayer.Stop();
                GD.Print("🎵 [BGMManager] BGMを停止しました。");
            }
        }

        public void SetVolume(float volumeDb)
        {
            _currentVolumeDb = volumeDb;
            if (_bgmPlayer != null)
            {
                _bgmPlayer.VolumeDb = volumeDb;
            }
        }
    }
}