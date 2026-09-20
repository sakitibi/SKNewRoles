shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;

void fragment() {
    vec2 uv = vec2(0.0);

    if (NORMAL.z > 0.5) {
        // 前面 (Front)
        uv = vec2(8.0 + UV.x * 8.0, 8.0 + UV.y * 8.0) / vec2(32.0, 16.0);
    } else if (NORMAL.z < -0.5) {
        // 背面 (Back)
        uv = vec2(24.0 + (1.0 - UV.x) * 8.0, 8.0 + UV.y * 8.0) / vec2(32.0, 16.0);
    } else if (NORMAL.x < -0.5) {
        // 左面 (Left)
        uv = vec2(16.0 + UV.x * 8.0, 8.0 + UV.y * 8.0) / vec2(32.0, 16.0);
    } else if (NORMAL.x > 0.5) {
        // 右面 (Right)
        uv = vec2(0.0 + UV.x * 8.0, 8.0 + UV.y * 8.0) / vec2(32.0, 16.0);
    } else if (NORMAL.y > 0.5) {
        // 上面 (Top)
        uv = vec2(8.0 + UV.x * 8.0, 0.0 + UV.y * 8.0) / vec2(32.0, 16.0);
    } else {
        // 下面 (Bottom)
        uv = vec2(16.0 + UV.x * 8.0, 0.0 + UV.y * 8.0) / vec2(32.0, 16.0);
    }

    ALBEDO = texture(texture_albedo, uv).rgb;
}