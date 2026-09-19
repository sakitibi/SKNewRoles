shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;

void fragment() {
    vec3 n = abs(NORMAL);
    vec2 uv = vec2(0.0);

    // 法線の向きに応じて UV 領域をオフセット計算
    if (NORMAL.z > 0.5) {
        // 前面 (Front) -> グリッド (1, 1)
        uv = (vec2(1.0, 1.0) + UV) / vec2(4.0, 3.0);
    } else if (NORMAL.z < -0.5) {
        // 背面 (Back) -> グリッド (3, 1)
        uv = (vec2(3.0, 1.0) + vec2(1.0 - UV.x, UV.y)) / vec2(4.0, 3.0);
    } else if (NORMAL.x < -0.5) {
        // 左面 (Left) -> グリッド (0, 1)
        uv = (vec2(0.0, 1.0) + UV) / vec2(4.0, 3.0);
    } else if (NORMAL.x > 0.5) {
        // 右面 (Right) -> グリッド (2, 1)
        uv = (vec2(2.0, 1.0) + UV) / vec2(4.0, 3.0);
    } else if (NORMAL.y > 0.5) {
        // 上面 (Top) -> グリッド (1, 0)
        uv = (vec2(1.0, 0.0) + UV) / vec2(4.0, 3.0);
    } else {
        // 下面 (Bottom) -> グリッド (1, 2)
        uv = (vec2(1.0, 2.0) + UV) / vec2(4.0, 3.0);
    }

    ALBEDO = texture(texture_albedo, uv).rgb;
}