#include "grass_block.h"
#include <godot_cpp/classes/shader.hpp>
#include <godot_cpp/classes/shader_material.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/engine.hpp>

using namespace godot;

void SNR2GrassBlock::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_grass_color"), &SNR2GrassBlock::get_grass_color);
    ClassDB::bind_method(D_METHOD("set_grass_color", "color"), &SNR2GrassBlock::set_grass_color);
    
    ADD_PROPERTY(PropertyInfo(Variant::COLOR, "grass_color"), "set_grass_color", "get_grass_color");
}

SNR2GrassBlock::SNR2GrassBlock() {
    grass_color = Color(0.2f, 0.8f, 0.2f, 1.0f);
}

SNR2GrassBlock::~SNR2GrassBlock() {
}

void SNR2GrassBlock::apply_color_to_mesh(const String &node_name) {
    MeshInstance3D *mesh = Object::cast_to<MeshInstance3D>(get_node_or_null(node_name));
    
    if (mesh != nullptr) {
        Ref<Material> mat = mesh->get_active_material(0);
        if (mat.is_valid()) {
            Ref<ShaderMaterial> shader_mat = mat->duplicate(true);
            if (shader_mat.is_valid()) {
                shader_mat->set_shader_parameter("grass_color", grass_color);
                mesh->set_material_override(shader_mat);
            }
        }
    } else {
        if (!Engine::get_singleton()->is_editor_hint()) {
            UtilityFunctions::printerr("Error: '" + node_name + "' node not found in SNR2GrassBlock during gameplay!");
        }
    }
}

void SNR2GrassBlock::_ready() {
    // 対象となる全ての面ノードの名前リスト
    static const String face_names[] = { "Top", "Front", "Back", "Left", "Right" };

    for (const String &name : face_names) {
        apply_color_to_mesh(name);
    }
}

void SNR2GrassBlock::set_grass_color(const Color p_color) {
    grass_color = p_color;
    
    if (is_inside_tree()) {
        static const String face_names[] = { "Top", "Front", "Back", "Left", "Right" };

        for (const String &name : face_names) {
            apply_color_to_mesh(name);
        }
    }
}

Color SNR2GrassBlock::get_grass_color() const {
    return grass_color;
}