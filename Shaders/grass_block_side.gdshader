shader_type spatial;

uniform sampler2D texture_albedo : source_color, filter_nearest;
uniform vec4 grass_color : source_color = vec4(0.2, 0.8, 0.2, 1.0);

void fragment() {
    vec4 tex_color = texture(texture_albedo, UV);
    vec3 final_color = tex_color.rgb;
    
    if (tex_color.g > tex_color.r && tex_color.g > tex_color.b && tex_color.g > 0.2) {
        // テクスチャの明暗（陰影ドット感）を取得
        float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
        
        final_color = grass_color.rgb * (gray * 1.5);
    }
    
    ALBEDO = final_color;
}