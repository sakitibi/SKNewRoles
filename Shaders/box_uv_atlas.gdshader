shader_type spatial;
render_mode unshaded;

uniform sampler2D texture_albedo : source_color, filter_nearest;

// 各部位のテクスチャ全体サイズ
uniform vec2 texture_size = vec2(32.0, 16.0);

// 各部位の直方体サイズ px
uniform vec2 box_size = vec2(8.0, 8.0);

varying vec3 local_pos;

void vertex() {
    // 頂点のローカル位置を取得
    local_pos = VERTEX;
}

void fragment() {
    float depth = box_size.x;
    float width = box_size.y;
    float height = texture_size.y - depth;

    // 各面ごとの 0.0 ~ 1.0 UV をメッシュ位置から直接算出
    vec2 face_uv = vec2(0.0);
    vec2 pixel_uv = vec2(0.0);

    if (NORMAL.z > 0.5) {
        // 前面 (Front)
        face_uv = vec2(local_pos.x + 0.5, 0.5 - local_pos.y);
        pixel_uv = vec2(depth + face_uv.x * width, depth + face_uv.y * height);
    } else if (NORMAL.z < -0.5) {
        // 背面 (Back)
        face_uv = vec2(0.5 - local_pos.x, 0.5 - local_pos.y);
        pixel_uv = vec2((depth * 2.0 + width) + face_uv.x * width, depth + face_uv.y * height);
    } else if (NORMAL.x < -0.5) {
        // 左面 (Left)
        face_uv = vec2(local_pos.z + 0.5, 0.5 - local_pos.y);
        pixel_uv = vec2((depth + width) + face_uv.x * depth, depth + face_uv.y * height);
    } else if (NORMAL.x > 0.5) {
        // 右面 (Right)
        face_uv = vec2(0.5 - local_pos.z, 0.5 - local_pos.y);
        pixel_uv = vec2(0.0 + face_uv.x * depth, depth + face_uv.y * height);
    } else if (NORMAL.y > 0.5) {
        // 上面 (Top)
        face_uv = vec2(local_pos.x + 0.5, local_pos.z + 0.5);
        pixel_uv = vec2(depth + face_uv.x * width, 0.0 + face_uv.y * depth);
    } else {
        // 下面 (Bottom)
        face_uv = vec2(local_pos.x + 0.5, 0.5 - local_pos.z);
        pixel_uv = vec2((depth + width) + face_uv.x * width, 0.0 + face_uv.y * depth);
    }

    vec2 final_uv = pixel_uv / texture_size;
    ALBEDO = texture(texture_albedo, final_uv).rgb;
}