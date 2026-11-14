using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace SKNewRoles2.Lobby
{
    public static class LobbyCountdownManager
    {
        public static Control Overlay { set; get; } = new()
        {
            AnchorLeft = 0,
            AnchorTop = 0,
            AnchorRight = 1,
            AnchorBottom = 1
        };
        
        // 半透明の黒背景
        public static ColorRect Bg { set; get; } = new()
        {
            AnchorLeft = 0,
            AnchorTop = 0,
            AnchorRight = 1,
            AnchorBottom = 1,
            Color = new Color(0, 0, 0, 0.25f)
        };

        // 中央に配置するカウントダウン用画像
        public static TextureRect CountdownTextureRect { set; get; } = new()
        {
            AnchorLeft = 0.5f,
            AnchorTop = 0.5f,
            AnchorRight = 0.5f,
            AnchorBottom = 0.5f,
            GrowHorizontal = Control.GrowDirection.Both,
            GrowVertical = Control.GrowDirection.Both,
            ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
            StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
            CustomMinimumSize = new Vector2(700, 700),
            PivotOffset = new Vector2(350, 350),
        };
        /// <summary>
        /// 画面中央に3秒間のカウントダウン画像を順番に表示し、その後にゲームステージへ遷移します
        /// </summary>
        public static async Task StartCountdownAndTransitionAsync(
            Node3D lobbyRoomNode, 
            Button startGameButton, 
            Button leaveButton, 
            IEnumerable<string> remotePlayerIds, 
            Action cleanupAction
        )
        {
            if (!GodotObject.IsInstanceValid(lobbyRoomNode) || !lobbyRoomNode.IsInsideTree()) return;

            // ボタンなどを無効化
            if (startGameButton != null && GodotObject.IsInstanceValid(startGameButton)) startGameButton.Disabled = true;
            if (leaveButton != null && GodotObject.IsInstanceValid(leaveButton)) leaveButton.Disabled = true;


            Overlay.AddChild(Bg);
            Overlay.AddChild(CountdownTextureRect);
            lobbyRoomNode.AddChild(Overlay);

            string[] counts = ["3", "2", "1"];
            foreach (string countStr in counts)
            {
                if (!GodotObject.IsInstanceValid(lobbyRoomNode)) break;

                string imagePath = $"user://game_asset/UI/countdown_{countStr}.png";

                if (FileAccess.FileExists(imagePath))
                {
                    Image img = Image.LoadFromFile(ProjectSettings.GlobalizePath(imagePath));
                    CountdownTextureRect.Texture = ImageTexture.CreateFromImage(img);
                }
                else
                {
                    GD.PrintErr($"⚠️ [LobbyCountdownManager] ファイルが存在しません: {imagePath}");
                }
                
                // 1秒待機
                await lobbyRoomNode.ToSignal(lobbyRoomNode.GetTree().CreateTimer(1.0f), SceneTreeTimer.SignalName.Timeout);
            }

            LobbyNavigation.TransitionToGameStage(lobbyRoomNode.GetTree(), remotePlayerIds, cleanupAction);
        }
    }
}