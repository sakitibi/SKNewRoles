#include "player_skin.h"
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/shader_material.hpp>
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/classes/image_texture.hpp>
#include <godot_cpp/classes/mesh.hpp>

namespace godot {
    void PlayerSkin::apply_custom_skins(Node3D *player_node) {
        if (!player_node) return;
        apply_part_skin(player_node, "SkinModel/Head", "head_atlas.png");
        apply_part_skin(player_node, "SkinModel/Body", "body_atlas.png");
        apply_part_skin(player_node, "SkinModel/RightArm", "rightarm_atlas.png");
        apply_part_skin(player_node, "SkinModel/LeftArm", "leftarm_atlas.png");
        apply_part_skin(player_node, "SkinModel/RightLeg", "rightleg_atlas.png");
        apply_part_skin(player_node, "SkinModel/LeftLeg", "leftleg_atlas.png");
    }

    void PlayerSkin::apply_part_skin(Node3D *player_node, const String &node_path, const String &file_name) {
        MeshInstance3D *mesh_instance = Object::cast_to<MeshInstance3D>(player_node->get_node_or_null(NodePath(node_path)));
        if (!mesh_instance || !mesh_instance->get_mesh().is_valid()) return;

        ProjectSettings *settings = ProjectSettings::get_singleton();
        String relative_path = "user://game_asset/Skins/" + file_name;
        String full_path = settings->globalize_path(relative_path);

        if (FileAccess::file_exists(full_path)) {
            Ref<Image> image = Image::load_from_file(full_path);
            if (image.is_valid()) {
                Ref<ImageTexture> texture = ImageTexture::create_from_image(image);
                Ref<Material> base_mat = mesh_instance->get_mesh()->surface_get_material(0);
                Ref<ShaderMaterial> shader_mat = base_mat;

                if (shader_mat.is_valid()) {
                    Ref<ShaderMaterial> unique_mat = shader_mat->duplicate();
                    unique_mat->set_shader_parameter("texture_albedo", texture);
                    mesh_instance->set_material_override(unique_mat);
                }
            }
        }
    }
}