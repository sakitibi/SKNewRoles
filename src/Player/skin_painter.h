#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/shader.hpp>
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/classes/image_texture.hpp>
#include <godot_cpp/classes/shader_material.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>
#include <map>

namespace godot {
    class SkinPainter : public Node3D {
        GDCLASS(SkinPainter, Node3D)

    private:
        Ref<Shader> atlas_shader;

        std::map<String, Ref<Image>> part_images;
        std::map<String, Ref<ImageTexture>> part_textures;
        std::map<String, Ref<ShaderMaterial>> part_materials;

        void setup_part(Node3D *root, const String &node_path);

    protected:
        static void _bind_methods();

    public:
        SkinPainter();
        ~SkinPainter();

        void set_atlas_shader(const Ref<Shader> &p_shader);
        Ref<Shader> get_atlas_shader() const;

        void initialize(Node3D *target_model);
        bool apply_preset_to_part(const String &part_name, const String &res_path);
        void apply_preset_to_all_parts(const Dictionary &equipped_presets);
    };
}