using Godot;
using SKNewRoles2.Lobby.JOIN.Models;
using SKNewRoles2.Lobby.JOIN.Services;
using System.Collections.Generic;

namespace SKNewRoles2.Lobby.JOIN
{
    public partial class JoinPublicLobby : Control
    {
        private VBoxContainer _lobbyListContainer;
        private Button _refreshButton;
        private Button _backButton;

        // 🎨 読み込むカスタムフォントのパス
        private const string FontPath = "res://Fonts/UDDigiKyokashoProN-Bold.ttf";
        private FontFile _cachedFont;

        // 生成される部屋選択ボタンのカラー設定
        [Export] public Color ButtonNormalColor { get; set; } = new Color(0.18f, 0.24f, 0.35f, 1.0f);
        [Export] public Color ButtonHoverColor { get; set; } = new Color(0.25f, 0.32f, 0.45f, 1.0f);

        public override void _Ready()
        {
            _lobbyListContainer = GetNode<VBoxContainer>("VBoxContainer/LobbyBasePanel/ScrollContainer/LobbyListContainer");
            _refreshButton = GetNode<Button>("VBoxContainer/LobbyBasePanel/RefreshButton");
            _backButton = GetNode<Button>("VBoxContainer/LobbyBasePanel/BackButton");

            _refreshButton.Pressed += OnRefreshButtonPressed;
            _backButton.Pressed += OnBackButtonPressed;

            // フォントリソースをあらかじめキャッシュ
            if (ResourceLoader.Exists(FontPath))
            {
                _cachedFont = GD.Load<FontFile>(FontPath);
            }

            // 画面表示時に初期リストを自動ロード
            RefreshLobbyListAsync();
        }

        /// <summary>
        /// Supabaseから最新の公開部屋をランダムに5件取得してUIリストを作成します。
        /// </summary>
        private async void RefreshLobbyListAsync()
        {
            if (_refreshButton == null || _lobbyListContainer == null) return;

            _refreshButton.Disabled = true;

            // コンテナ内の古い部屋ボタンを完全にクリア
            for (int i = _lobbyListContainer.GetChildren().Count - 1; i >= 0; i--)
            {
                _lobbyListContainer.GetChildren()[i].QueueFree();
            }

            GD.Print("🌐 Supabaseから公開ロビーを取得中...");
            List<LobbyData> lobbies = await LobbyQueryService.FetchRandomPublicLobbiesAsync();
            // 逆順ループの為にここで逆にする
            lobbies.Reverse();

            if (lobbies.Count == 0)
            {
                Label noLobbyLabel = new()
                {
                    Text = "現在公開されている部屋はありません。",
                    HorizontalAlignment = HorizontalAlignment.Center
                };
                
                if (_cachedFont != null)
                {
                    noLobbyLabel.AddThemeFontOverride("font", _cachedFont);
                    noLobbyLabel.AddThemeFontSizeOverride("font_size", 40);
                }

                _lobbyListContainer.AddChild(noLobbyLabel);
            }
            else
            {
                // 逆の逆は正なのでこれで最初の順番に戻る
                for (int i = lobbies.Count - 1; i >= 0; i--)
                {
                    // 部屋ごとに参加用のエントリーボタンを動的に作成
                    Button joinButton = new()
                    {
                        Text = $" 🏠  {lobbies[i].RoomName}   [{lobbies[i].RoomCode}]",
                        Alignment = HorizontalAlignment.Left
                    };
                    
                    if (_cachedFont != null)
                    {
                        joinButton.AddThemeFontOverride("font", _cachedFont);
                        joinButton.AddThemeFontSizeOverride("font_size", 45);
                    }

                    // ボタンの縦幅にある程度余裕を持たせる設定
                    joinButton.CustomMinimumSize = new Vector2(0, 90);

                    // 動的ボタンの見た目（スタイル）を調整
                    var normalStyle = new StyleBoxFlat { BgColor = ButtonNormalColor };
                    normalStyle.SetCornerRadiusAll(8);
                    var hoverStyle = new StyleBoxFlat { BgColor = ButtonHoverColor };
                    hoverStyle.SetCornerRadiusAll(8);
                    
                    joinButton.AddThemeStyleboxOverride("normal", normalStyle);
                    joinButton.AddThemeStyleboxOverride("hover", hoverStyle);

                    // 変数のキャプチャ問題を回避してイベントをバインド
                    string targetCode = lobbies[i].RoomCode;
                    joinButton.Pressed += () => OnJoinLobbyClicked(targetCode);

                    _lobbyListContainer.AddChild(joinButton);
                }
            }

            _refreshButton.Disabled = false;
        }

        private void OnRefreshButtonPressed()
        {
            RefreshLobbyListAsync();
        }

        private async void OnJoinLobbyClicked(string roomCode)
        {
            GD.Print($"🔑 公開ロビー [{roomCode}] への接続を処理中...");
            
            bool success = await LobbyQueryService.JoinLobbyAsync(roomCode);

            if (success)
            {
                GD.Print("🚀 入室に成功しました。3Dロビールームへ移動します。");
                GetTree().ChangeSceneToFile("res://Scenes/LobbyRoom3D.tscn"); 
            }
            else
            {
                GD.PrintErr("❌ 入室に失敗しました。部屋が満員か、解散された可能性があります。");
                RefreshLobbyListAsync();
            }
        }

        private void OnBackButtonPressed()
        {
            GetTree().ChangeSceneToFile("res://Scenes/LobbySelect.tscn");
        }
    }
}