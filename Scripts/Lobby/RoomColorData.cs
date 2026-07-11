using Godot;

namespace SKNewRoles2.Lobby
{
    public class RoomColorData
    {
        // ==========================================
        // 🎯 [MOD API] 外部から自由に変更可能なカラープロパティ
        // ==========================================
        // 公開中（Public）の各状態カラー
        public static Color PublicNormalColor { get; set; } = new Color(0.2f, 0.85f, 0.3f, 1.0f);
        public static Color PublicHoverColor { get; set; } = new Color(0.3f, 0.95f, 0.4f, 1.0f);
        public static Color PublicPressedColor { get; set; } = new Color(0.15f, 0.7f, 0.2f, 1.0f);

        // 非公開（Private）の各状態カラー
        public static Color PrivateNormalColor { get; set; } = new Color(0.85f, 0.25f, 0.25f, 1.0f);
        public static Color PrivateHoverColor { get; set; } = new Color(0.95f, 0.35f, 0.35f, 1.0f);
        public static Color PrivatePressedColor { get; set; } = new Color(0.7f, 0.15f, 0.15f, 1.0f);
    }
}