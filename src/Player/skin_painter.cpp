#include "skin_painter.h"
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

SkinPainter::SkinPainter() {}
SkinPainter::~SkinPainter() {}

void SkinPainter::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_atlas_shader", "p_shader"), &SkinPainter::set_atlas_shader);
    ClassDB::bind_method(D_METHOD("get_atlas_shader"), &SkinPainter::get_atlas_shader);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "atlas_shader", PROPERTY_HINT_RESOURCE_TYPE, "Shader"), "set_atlas_shader", "get_atlas_shader");

    ClassDB::bind_method(D_METHOD("initialize", "target_model"), &SkinPainter::initialize);
    ClassDB::bind_method(D_METHOD("apply_preset_to_part", "part_name", "res_path"), &SkinPainter::apply_preset_to_part);
    ClassDB::bind_method(D_METHOD("apply_preset_to_all_parts", "equipped_presets"), &SkinPainter::apply_preset_to_all_parts);
}

void SkinPainter::set_atlas_shader(const Ref<Shader> &p_shader) {
    atlas_shader = p_shader;
}

Ref<Shader> SkinPainter::get_atlas_shader() const {
    return atlas_shader;
}

void SkinPainter::initialize(Node3D *target_model) {
    setup_part(target_model, "SkinModel/Head");
    setup_part(target_model, "SkinModel/Body");
    setup_part(target_model, "SkinModel/RightArm");
    setup_part(target_model, "SkinModel/LeftArm");
    setup_part(target_model, "SkinModel/RightLeg");
    setup_part(target_model, "SkinModel/LeftLeg");
}

void SkinPainter::setup_part(Node3D *root, const String &node_path) {
    if (!root) return;
    
    MeshInstance3D *mesh_instance = Object::cast_to<MeshInstance3D>(root->get_node_or_null(node_path));
    if (!mesh_instance) return;

    String part_name = mesh_instance->get_name();

    Vector2i res(32, 16);
    Vector2 box_size(8.0f, 8.0f);

    if (part_name == "Head") {
        res = Vector2i(32, 16); box_size = Vector2(8.0f, 8.0f);
    } else if (part_name == "Body") {
        res = Vector2i(24, 16); box_size = Vector2(4.0f, 8.0f);
    } else if (part_name == "RightArm" || part_name == "LeftArm") {
        res = Vector2i(16, 16); box_size = Vector2(4.0f, 4.0f);
    } else if (part_name == "RightLeg" || part_name == "LeftLeg") {
        res = Vector2i(16, 16); box_size = Vector2(4.0f, 4.0f);
    }

    Ref<Image> image = Image::create_empty(res.x, res.y, false, Image::FORMAT_RGBA8);
    if (image.is_valid()) {
        image->fill(Color(1, 1, 1, 1));
    }

    Ref<ImageTexture> dyn_texture = ImageTexture::create_from_image(image);
    Ref<ShaderMaterial> mat;

    Ref<Material> override_mat = mesh_instance->get_material_override();
    if (override_mat.is_valid() && Object::cast_to<ShaderMaterial>(override_mat.ptr())) {
        mat = Ref<ShaderMaterial>(override_mat->duplicate());
    } else {
        Ref<Material> active_mat = mesh_instance->get_active_material(0);
        if (active_mat.is_valid() && Object::cast_to<ShaderMaterial>(active_mat.ptr())) {
            mat = Ref<ShaderMaterial>(active_mat->duplicate());
        } else if (atlas_shader.is_valid()) {
            mat.instantiate();
            mat->set_shader(atlas_shader);
        }
    }

    if (mat.is_valid()) {
        mat->set_shader_parameter("texture_albedo", dyn_texture);
        mat->set_shader_parameter("texture_size", Vector2(res.x, res.y));
        mat->set_shader_parameter("box_size", box_size);

        mesh_instance->set_material_override(mat);

        part_images[part_name] = image;
        part_textures[part_name] = dyn_texture;
        part_materials[part_name] = mat;
    } else {
        UtilityFunctions::push_error(vformat("[SkinPainter] %s の ShaderMaterial 取得に失敗しました。", part_name));
    }
}

bool SkinPainter::apply_preset_to_part(const String &part_name, const String &res_path) {
    if (part_images.find(part_name) == part_images.end()) {
        UtilityFunctions::push_error(vformat("[SkinPainter] 未登録の部位です: %s", part_name));
        return false;
    }

    ResourceLoader *rl = ResourceLoader::get_singleton();
    if (!rl->exists(res_path)) {
        UtilityFunctions::push_error(vformat("[SkinPainter] プリセット画像が見つかりません: %s", res_path));
        return false;
    }

    Ref<Texture2D> texture = rl->load(res_path);
    if (!texture.is_valid()) {
        UtilityFunctions::push_error(vformat("[SkinPainter] テクスチャのロードに失敗しました: %s", res_path));
        return false;
    }

    Ref<Image> loaded_image = texture->get_image();
    if (!loaded_image.is_valid()) return false;

    if (loaded_image->get_format() != Image::FORMAT_RGBA8) {
        loaded_image->convert(Image::FORMAT_RGBA8);
    }

    Vector2i target_res(32, 16);
    Vector2 box_size(8.0f, 8.0f);

    if (part_name == "Head") {
        target_res = Vector2i(32, 16); box_size = Vector2(8.0f, 8.0f);
    } else if (part_name == "Body") {
        target_res = Vector2i(24, 16); box_size = Vector2(4.0f, 8.0f);
    } else if (part_name == "RightArm" || part_name == "LeftArm") {
        target_res = Vector2i(16, 16); box_size = Vector2(4.0f, 4.0f);
    } else if (part_name == "RightLeg" || part_name == "LeftLeg") {
        target_res = Vector2i(16, 16); box_size = Vector2(4.0f, 4.0f);
    }

    if (loaded_image->get_width() != target_res.x || loaded_image->get_height() != target_res.y) {
        loaded_image->resize(target_res.x, target_res.y, Image::INTERPOLATE_NEAREST);
    }

    Ref<ImageTexture> new_texture = ImageTexture::create_from_image(loaded_image);

    part_images[part_name] = loaded_image;
    part_textures[part_name] = new_texture;

    auto it = part_materials.find(part_name);
    if (it != part_materials.end() && it->second.is_valid()) {
        Ref<ShaderMaterial> mat = it->second;
        mat->set_shader_parameter("texture_albedo", new_texture);
        mat->set_shader_parameter("texture_size", Vector2(target_res.x, target_res.y));
        mat->set_shader_parameter("box_size", box_size);
    }

    UtilityFunctions::print(vformat("[SkinPainter] %s にプリセットを適用しました: %s", part_name, res_path));
    return true;
}

void SkinPainter::apply_preset_to_all_parts(const Dictionary &equipped_presets) {
    Array keys = equipped_presets.keys();
    for (int i = 0; i < keys.size(); i++) {
        String part_name = keys[i];
        String preset_id = equipped_presets[part_name];
        String part_lower = part_name.to_lower();
        String res_path = vformat("res://Resources/Skins/%s/%s.png", preset_id, part_lower);
        apply_preset_to_part(part_name, res_path);
    }
}