using Godot;
using System.Threading.Tasks;

namespace SKNewRoles2.Game
{
    public partial class GameUIController : Node
    {
        private Control _loadingScene;
        private Control _roleRevealScene;
        private ProgressBar _hpBar;
        private Label _hpLabel;
        private Label _factionLabel;
        private Label _roleTitleLabel;
        private Label _descriptionLabel;
        private Label _coordsLabel;
        private Node _hudManager;

        public void Initialize(Node parentNode)
        {
            if (parentNode == null)
            {
                GD.PrintErr("❌ [GameUIController] parentNode が null です。");
                return;
            }

            _loadingScene = parentNode.GetNode<Control>("UILayer/LoadingScene");
            _roleRevealScene = parentNode.GetNode<Control>("UILayer/RoleRevealScene");
            _hpBar = parentNode.GetNode<ProgressBar>("UILayer/HPBar");
            _hpLabel = parentNode.GetNode<Label>("UILayer/HPBar/HPLabel");

            // 座標表示用ラベル
            _coordsLabel = parentNode.GetNode<Label>("HUDManager/PositionText");

            _hudManager = parentNode.GetNodeOrNull<Node>("HUDManager");

            // --- ノード取得チェックログ ---
            GD.Print($"🔍 [UI Check] LoadingScene: {(_loadingScene != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] HPBar: {(_hpBar != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] HPLabel: {(_hpLabel != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] PositionText (Coords): {(_coordsLabel != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] HUDManager (C++): {(_hudManager != null ? "✅ Found" : "❌ Not Found")}");

            if (_roleRevealScene != null)
            {
                _factionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/FactionLabel");
                _roleTitleLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/RoleTitleLabel");
                _descriptionLabel = _roleRevealScene.GetNodeOrNull<Label>("MainContainer/VBoxContainer/DescriptionLabel");

                _roleRevealScene.Visible = false;
            }

            if (_loadingScene != null)
            {
                _loadingScene.Visible = true;
            }
            else
            {
                GD.PrintErr("❌ [GameUIController] LoadingScene が見つかりませんでした。");
            }
        }

        public void SetPlayerPathToHud(NodePath playerPath)
        {
            if (_hudManager != null && IsInstanceValid(_hudManager))
            {
                _hudManager.Call("set_player_path", playerPath);
            }
        }

        public void SetLabelPathToHud(NodePath labelPath)
        {
            if (_hudManager != null && IsInstanceValid(_hudManager))
            {
                _hudManager.Call("set_label_path", labelPath);
            }
        }

        public void SetFpsLabelPathToHud(NodePath fpsLabelPath)
        {
            if (_hudManager != null && IsInstanceValid(_hudManager))
            {
                _hudManager.Call("set_fps_label_path", fpsLabelPath);
            }
        }

        public void UpdateHp(int currentHp, int maxHp)
        {
            if (_hpBar != null)
            {
                _hpBar.MaxValue = maxHp;
                _hpBar.Value = currentHp;
            }

            _hpLabel.Text = $"{currentHp} / {maxHp}";
        }

        public void UpdateCoords(Vector3 position)
        {
            _coordsLabel.Text = $"X: {position.X:F1} Y: {position.Y:F1} Z: {position.Z:F1}";
        }

        public void HideLoadingScene()
        {
            if (_loadingScene != null && IsInstanceValid(_loadingScene))
            {
                _loadingScene.Visible = false;
                _loadingScene.QueueFree();
                _loadingScene = null;
                GD.Print("🧹 [UI] LoadingScene を破棄しました。");
            }
        }

        public async Task ShowRoleRevealAsync(int roleId, int factionId, int displayTimeMs = 5000)
        {
            if (_roleRevealScene == null) return;

            _factionLabel.Text = RoleInfo.GetFactionName(factionId);
            _roleTitleLabel.Text = RoleInfo.GetRoleName(roleId);
            _descriptionLabel.Text = RoleInfo.GetRoleDescription(roleId);

            _roleRevealScene.Visible = true;
            _roleRevealScene.MoveToFront();

            GD.Print($"7️⃣ [UI] 役職画面を表示しました ({displayTimeMs / 1000}秒表示)");
            await Task.Delay(displayTimeMs);

            if (IsInstanceValid(_roleRevealScene))
            {
                _roleRevealScene.Visible = false;
                GD.Print("8️⃣ [UI] 役職画面を非表示にしました");
            }
        }
    }
}