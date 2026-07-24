#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/standard_material3d.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/core/memory.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

// 子ノードからマテリアルを取得する補助関数
Ref<Material> get_node_material(MeshInstance3D *mi, int surface_idx = 0) {
    if (!mi) return Ref<Material>();

    // 1. material_override を優先して確認
    Ref<Material> mat = mi->get_material_override();
    if (mat.is_valid()) {
        return mat;
    }

    // 2. MeshInstance3D の surface_material_override を確認
    mat = mi->get_surface_override_material(surface_idx);
    if (mat.is_valid()) {
        return mat;
    }

    // 3. メッシュ自体のサーフェスマテリアルを確認
    Ref<Mesh> mesh = mi->get_mesh();
    if (mesh.is_valid() && surface_idx < mesh->get_surface_count()) {
        mat = mesh->surface_get_material(surface_idx);
        if (mat.is_valid()) {
            return mat;
        }
    }

    return Ref<Material>();
}

// 取得したマテリアルから Texture2D を抽出する例
Ref<Texture2D> get_albedo_texture_from_material(const Ref<Material> &mat) {
    if (mat.is_null()) return Ref<Texture2D>();

    // StandardMaterial3D にキャストして Albedo テクスチャを取得
    Ref<StandardMaterial3D> std_mat = mat;
    if (std_mat.is_valid()) {
        return std_mat->get_texture(StandardMaterial3D::TEXTURE_ALBEDO);
    }

    return Ref<Texture2D>();
}

// シーン全体から全子ノードのマテリアルとテクスチャ情報を抽出するメイン処理
void inspect_block_scene_materials(const String &scene_path) {
    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    if (scene.is_null()) return;

    Node *inst = scene->instantiate();
    if (!inst) return;

    Node3D *root_node = Object::cast_to<Node3D>(inst);
    if (root_node) {
        for (int i = 0; i < root_node->get_child_count(); ++i) {
            MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(root_node->get_child(i));
            if (!mi) continue;

            String node_name = mi->get_name();
            Ref<Material> mat = get_node_material(mi, 0);

            if (mat.is_valid()) {
                Ref<Texture2D> tex = get_albedo_texture_from_material(mat);
                String tex_path = tex.is_valid() ? tex->get_path() : "None";
                
                UtilityFunctions::print("Child Node [", node_name, "] -> Material: ", mat->get_class(), ", Texture: ", tex_path);
            } else {
                UtilityFunctions::print("Child Node [", node_name, "] -> Material: Null");
            }
        }
    }

    memdelete(inst);
}