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

        public void Initialize(Node parentNode)
        {
            // UILayer/LoadingScene を取得 (内部は StartupScene.tscn)
            _loadingScene = parentNode.GetNodeOrNull<Control>("UILayer/LoadingScene");
            _roleRevealScene = parentNode.GetNodeOrNull<Control>("UILayer/RoleRevealScene");
            _hpBar = parentNode.GetNodeOrNull<ProgressBar>("UILayer/HPBar");
            _hpLabel = parentNode.GetNodeOrNull<Label>("UILayer/HPBar/HPLabel");

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
                GD.PrintErr("❌ [GameUIController] UILayer/LoadingScene が見つかりませんでした。");
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

        public void HideLoadingScene()
        {
            if (_loadingScene != null && IsInstanceValid(_loadingScene))
            {
                _loadingScene.Visible = false;
                
                _loadingScene.QueueFree();
                _loadingScene = null;
                
                GD.Print("🧹 [UI] LoadingScene (StartupScene) を完全に消去・破棄しました。");
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

            GD.Print($"7️⃣ [UI] 役職画面を表示しました ({displayTimeMs / 1000}秒カウント開始)");
            await Task.Delay(displayTimeMs);

            if (IsInstanceValid(_roleRevealScene))
            {
                _roleRevealScene.Visible = false;
                GD.Print("8️⃣ [UI] 役職画面を非表示にしました");
            }
        }
    }
}