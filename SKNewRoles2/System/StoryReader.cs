using Godot;
using SKNewRoles2.Game.BGM;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Threading.Tasks;

namespace SKNewRoles2.SNRSystem
{
    public partial class StoryReader : Control
    {
        private static readonly string[] LineSeparators = ["\r\n", "\r", "\n"];

        private RichTextLabel _storyLabel;
        private Button _nextButton;
        private Button _skipButton;
        private BGMManager _bgmManager;
        private static MemoryStream _inputStream;
        private static BrotliStream _brotliStream;
        private static MemoryStream _outputStream;

        private List<string> _storyPages = [];
        private int _currentPageIndex = 0;

        private const string DefaultStoryPath = "res://Resources/Stories/first_story.txt.br";
        private const string ModStoryPath = "user://mods/first_story.br";

        public override async void _Ready()
        {
            _storyLabel = GetNode<RichTextLabel>("MarginContainer/VBoxContainer/StoryPanel/MarginContainer/StoryLabel");
            _nextButton = GetNode<Button>("MarginContainer/VBoxContainer/ButtonContainer/NextButton");
            _skipButton = GetNode<Button>("MarginContainer/VBoxContainer/ButtonContainer/SkipButton");
            _bgmManager = GetNode<BGMManager>("BGMManager");

            _nextButton.Pressed += OnNextButtonPressed;
            _skipButton.Pressed += OnSkipButtonPressed;

            await LoadStoryData();
            ShowCurrentPage();
        }

        private async Task LoadStoryData()
        {
            string targetPath = DefaultStoryPath;

            if (Godot.FileAccess.FileExists(ModStoryPath))
            {
                targetPath = ModStoryPath;
                GD.Print("[StoryReader] MODストーリー(.br)を検知しました: " + ModStoryPath);
            }

            if (!Godot.FileAccess.FileExists(targetPath))
            {
                GD.PrintErr("[StoryReader] ストーリーファイルが見つかりません: " + targetPath);
                _storyPages = ["ストーリーファイルの読み込みに失敗しました。"];
                return;
            }

            try
            {
                Godot.FileAccess file = Godot.FileAccess.Open(targetPath, Godot.FileAccess.ModeFlags.Read);
                byte[] compressedBytes = file.GetBuffer((long)file.GetLength());

                string decompressedText = await DecompressBrotli(compressedBytes);

                _storyPages.Clear();

                string[] lines = decompressedText.Split(LineSeparators, StringSplitOptions.RemoveEmptyEntries);

                foreach (string line in lines)
                {
                    string trimmed = line.Trim();
                    if (!string.IsNullOrEmpty(trimmed))
                    {
                        _storyPages.Add(trimmed);
                    }
                }
            }
            catch (Exception e)
            {
                GD.PrintErr("[StoryReader] Brotli解凍中にエラーが発生しました: " + e.Message);
                _storyPages = ["ストーリーファイルの解凍に失敗しました。"];
                return;
            }

            if (_storyPages.Count == 0)
            {
                _storyPages.Add("ストーリーテキストが空です。");
            }
        }

        private static async Task<string> DecompressBrotli(byte[] compressedData)
        {
            _inputStream = new MemoryStream(compressedData);
            _brotliStream = new BrotliStream(_inputStream, CompressionMode.Decompress);
            _outputStream = new();
            
            _brotliStream.CopyTo(_outputStream);
            byte[] decompressedBytes = _outputStream.ToArray();

            return Encoding.UTF8.GetString(decompressedBytes);
        }

        private void ShowCurrentPage()
        {
            if (_currentPageIndex < _storyPages.Count)
            {
                _storyLabel.Text = _storyPages[_currentPageIndex];

                if (_currentPageIndex == _storyPages.Count - 1)
                {
                    _nextButton.Text = "次へ進む";
                }
            }
            else
            {
                ProceedToLobbySelect();
            }
        }

        private async void OnNextButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            _currentPageIndex++;
            ShowCurrentPage();
        }

        private async void OnSkipButtonPressed()
        {
            uint[] buttonClickSoundIdx = [5];
            _ = _bgmManager.PlayBgm(2.0f, buttonClickSoundIdx, false);
            await Task.Delay(250); // クリック音を鳴らす為
            ProceedToLobbySelect();
        }

        private void ProceedToLobbySelect()
        {
            Error error = GetTree().ChangeSceneToFile("res://Scenes/LobbySelect.tscn");
            if (error != Error.Ok)
            {
                GD.PrintErr("ロビー選択画面への遷移に失敗しました: " + error);
            }
        }
    }
}