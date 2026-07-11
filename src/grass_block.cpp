#include "grass_block.h"
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/classes/standard_material3d.hpp>
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

void SNR2GrassBlock::_ready() {
    MeshInstance3D *top_mesh = Object::cast_to<MeshInstance3D>(get_node_or_null("Top"));
    
    if (top_mesh != nullptr) {
        Ref<Material> mat = top_mesh->get_material_override();
        if (mat.is_null()) {
            mat = top_mesh->get_active_material(0);
        }
        
        if (mat.is_valid()) {
            Ref<StandardMaterial3D> std_mat = mat->duplicate();
            
            if (std_mat.is_valid()) {
                std_mat->set_albedo(grass_color);
                // 強力な material_override 側へセットして、強制反映させる
                top_mesh->set_material_override(std_mat);
            }
        }
    } else {
        if (!Engine::get_singleton()->is_editor_hint()) {
            UtilityFunctions::printerr("Error: 'Top' node not found in SNR2GrassBlock during gameplay!");
        }
    }
}

void SNR2GrassBlock::set_grass_color(const Color p_color) {
    grass_color = p_color;
    
    if (is_inside_tree()) {
        MeshInstance3D *top_mesh = Object::cast_to<MeshInstance3D>(get_node_or_null("Top"));
        if (top_mesh != nullptr) {
            Ref<StandardMaterial3D> std_mat = top_mesh->get_material_override();
            if (std_mat.is_valid()) {
                std_mat->set_albedo(grass_color);
            } else {
                // 保険処理
                Ref<Material> mat = top_mesh->get_active_material(0);
                if (mat.is_valid()) {
                    Ref<StandardMaterial3D> std_mat_base = mat->duplicate();
                    if (std_mat_base.is_valid()) {
                        std_mat_base->set_albedo(grass_color);
                        top_mesh->set_material_override(std_mat_base);
                    }
                }
            }
        }
    }
}

Color SNR2GrassBlock::get_grass_color() const {
    return grass_color;
}