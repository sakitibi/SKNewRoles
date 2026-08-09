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

        public void Initialize(Node parentNode)
        {
            if (parentNode == null)
            {
                GD.PrintErr("❌ [GameUIController] parentNode が null です。");
                return;
            }

            _loadingScene = parentNode.GetNodeOrNull<Control>("UILayer/LoadingScene");
            _roleRevealScene = parentNode.GetNodeOrNull<Control>("UILayer/RoleRevealScene");
            _hpBar = parentNode.GetNodeOrNull<ProgressBar>("UILayer/HPBar");
            _hpLabel = parentNode.GetNodeOrNull<Label>("UILayer/HPBar/HPLabel");

            // 座標表示用ラベル
            _coordsLabel = parentNode.GetNodeOrNull<Label>("HUDManager/PositionText");

            // --- ノード取得チェックログ ---
            GD.Print($"🔍 [UI Check] LoadingScene: {(_loadingScene != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] HPBar: {(_hpBar != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] HPLabel: {(_hpLabel != null ? "✅ Found" : "❌ Not Found")}");
            GD.Print($"🔍 [UI Check] PositionText (Coords): {(_coordsLabel != null ? "✅ Found" : "❌ Not Found")}");

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

        public void UpdateHp(int currentHp, int maxHp)
        {
            if (_hpBar != null)
            {
                _hpBar.MaxValue = maxHp;
                _hpBar.Value = currentHp;
            }
            if (_hpLabel != null)
            {
                _hpLabel.Text = $"{currentHp} / {maxHp}";
            }
        }

        public void UpdateCoords(Vector3 position)
        {
            if (_coordsLabel != null)
            {
                _coordsLabel.Text = $"X: {position.X:F1} Y: {position.Y:F1} Z: {position.Z:F1}";
            }
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

            if (_factionLabel != null) _factionLabel.Text = RoleInfo.GetFactionName(factionId);
            if (_roleTitleLabel != null) _roleTitleLabel.Text = RoleInfo.GetRoleName(roleId);
            if (_descriptionLabel != null) _descriptionLabel.Text = RoleInfo.GetRoleDescription(roleId);

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