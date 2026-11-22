using Godot;

namespace SKNewRoles2.SNRSystem
{
    public partial class ButtonAnimation : Node2D
    {
        public Vector2 MouseEnteredScale = new(1.08f, 1.08f);
        public Vector2 MouseExitedScale = Vector2.One;
        public Vector2 ButtonDownScale = new(0.95f, 0.95f);
        public Vector2 ButtonUpScale = new(1.08f, 1.08f);
        public float MouseEnteredDuration = 0.1f;
        public float MouseExitedDuration = 0.1f;
        public float ButtonDownDuration = 0.05f;
        public float ButtonUpDuration = 0.05f;
        
        /// <summary>
        /// ボタンにホバー時・押下時の滑らかな拡大縮小アニメーションを設定
        /// </summary>
        public void SetupButtonAnimation(Button button)
        {
            button.PivotOffset = button.Size / 2;

            // マウスホバー時
            button.MouseEntered += () => AnimateScale(button, MouseEnteredScale, MouseEnteredDuration);
            // マウス離脱時
            button.MouseExited += () => AnimateScale(button, MouseExitedScale, MouseExitedDuration);
            // ボタンを押した瞬間
            button.ButtonDown += () => AnimateScale(button, ButtonDownScale, ButtonDownDuration);
            // ボタンを離した時
            button.ButtonUp += () => AnimateScale(button, ButtonUpScale, ButtonUpDuration);
        }

        /// <summary>
        /// Tweenを使ってスケールを変更する共通メソッド
        /// </summary>
        private void AnimateScale(Button button, Vector2 targetScale, double duration)
        {
            Tween tween = CreateTween().SetTrans(Tween.TransitionType.Sine).SetEase(Tween.EaseType.Out);
            tween.TweenProperty(button, "scale", targetScale, duration);
        }
    }
}