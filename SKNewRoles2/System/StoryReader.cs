using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Text;

namespace SKNewRoles2.SNRSystem
{
    public partial class StoryReader : Control
    {
        private static readonly string[] LineSeparators = ["\r\n", "\r", "\n"];

        private RichTextLabel _storyLabel;
        private Button _nextButton;
        private Button _skipButton;

        private List<string> _storyPages = [];
        private int _currentPageIndex = 0;

        private const string DefaultStoryPath = "res://Resources/Stories/first_story.txt.br";
        private const string ModStoryPath = "user://mods/first_story.br";

        public override void _Ready()
        {
            _storyLabel = GetNode<RichTextLabel>("MarginContainer/VBoxContainer/StoryPanel/MarginContainer/StoryLabel");
            _nextButton = GetNode<Button>("MarginContainer/VBoxContainer/ButtonContainer/NextButton");
            _skipButton = GetNode<Button>("MarginContainer/VBoxContainer/ButtonContainer/SkipButton");

            _nextButton.Pressed += OnNextButtonPressed;
            _skipButton.Pressed += OnSkipButtonPressed;

            LoadStoryData();
            ShowCurrentPage();
        }

        private void LoadStoryData()
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
                using var file = Godot.FileAccess.Open(targetPath, Godot.FileAccess.ModeFlags.Read);
                byte[] compressedBytes = file.GetBuffer((long)file.GetLength());

                string decompressedText = DecompressBrotli(compressedBytes);

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

        private static string DecompressBrotli(byte[] compressedData)
        {
            using var inputStream = new MemoryStream(compressedData);
            using var brotliStream = new BrotliStream(inputStream, CompressionMode.Decompress);
            using var outputStream = new MemoryStream();
            
            brotliStream.CopyTo(outputStream);
            byte[] decompressedBytes = outputStream.ToArray();

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

        private void OnNextButtonPressed()
        {
            _currentPageIndex++;
            ShowCurrentPage();
        }

        private void OnSkipButtonPressed()
        {
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