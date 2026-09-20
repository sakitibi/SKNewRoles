shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;

// 各部位のテクスチャ全体サイズ
uniform vec2 texture_size = vec2(32.0, 16.0);

uniform vec2 box_size = vec2(8.0, 8.0);

void fragment() {
    float depth = box_size.x; // 奥行き (側面・天面の縦幅)
    float width = box_size.y; // 横幅   (正面・背面の横幅)
    float height = texture_size.y - depth; // 高さ (Y方向の側面領域幅)

    vec2 pixel_uv = vec2(0.0);

    if (NORMAL.z > 0.5) {
        // 前面 (Front): X = depth ~ (depth + width), Y = depth ~ (depth + height)
        pixel_uv = vec2(depth + UV.x * width, depth + UV.y * height);
    } else if (NORMAL.z < -0.5) {
        // 背面 (Back): X = (depth*2 + width) ~ (depth*2 + width*2), Y = depth ~ (depth + height)
        pixel_uv = vec2((depth * 2.0 + width) + (1.0 - UV.x) * width, depth + UV.y * height);
    } else if (NORMAL.x < -0.5) {
        // 左面 (Left): X = (depth + width) ~ (depth*2 + width), Y = depth ~ (depth + height)
        pixel_uv = vec2((depth + width) + UV.x * depth, depth + UV.y * height);
    } else if (NORMAL.x > 0.5) {
        // 右面 (Right): X = 0 ~ depth, Y = depth ~ (depth + height)
        pixel_uv = vec2(0.0 + UV.x * depth, depth + UV.y * height);
    } else if (NORMAL.y > 0.5) {
        // 上面 (Top): X = depth ~ (depth + width), Y = 0 ~ depth
        pixel_uv = vec2(depth + UV.x * width, 0.0 + UV.y * depth);
    } else {
        // 下面 (Bottom): X = (depth + width) ~ (depth + width*2), Y = 0 ~ depth
        pixel_uv = vec2((depth + width) + UV.x * width, 0.0 + UV.y * depth);
    }

    // 各部位のテクスチャ解像度で割り算して 0.0 ~ 1.0 に正規化
    vec2 final_uv = pixel_uv / texture_size;

    ALBEDO = texture(texture_albedo, final_uv).rgb;
}