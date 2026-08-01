#include "block_mesh_cache.h"
#include "block_registry.h"

#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/base_material3d.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

static HashMap<String, BlockMeshData> mesh_cache;

BlockMeshCache::BlockMeshCache() {}
BlockMeshCache::~BlockMeshCache() {}

void BlockMeshCache::_bind_methods() {
    ClassDB::bind_static_method("BlockMeshCache", D_METHOD("preload_block_meshes"), &BlockMeshCache::preload_block_meshes);
    ClassDB::bind_static_method("BlockMeshCache", D_METHOD("clear_cache"), &BlockMeshCache::clear_cache);
}

void BlockMeshCache::preload_block_meshes() {
    mesh_cache.clear();
    const HashMap<String, String> &registry_map = BlockRegistry::get_block_scene_map();

    static const char* FACE_NODE_NAMES[6] = {
        "Top", "Bottom", "Back", "Front", "Right", "Left"
    };

    for (const auto &E : registry_map) {
        String scene_path = E.value;

        if (!ResourceLoader::get_singleton()->exists(scene_path)) continue;

        Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
        if (scene.is_null()) continue;

        Node3D *inst = Object::cast_to<Node3D>(scene->instantiate());
        if (!inst) continue;

        BlockMeshData data;
        data.materials.resize(6);

        // テクスチャファイルパスに基づく重複マテリアル統合マップ
        HashMap<String, Ref<Material>> material_dedup_map;

        // 各面のノードからマテリアルを取得
        for (int i = 0; i < 6; ++i) {
            Node *child = inst->find_child(FACE_NODE_NAMES[i], true, false);
            MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(child);

            if (mi) {
                Ref<Material> mat = mi->get_material_override();
                if (mat.is_null()) {
                    mat = mi->get_active_material(0);
                }

                if (mat.is_valid()) {
                    String mat_key;
                    Ref<BaseMaterial3D> base_mat = mat;
                    if (base_mat.is_valid()) {
                        Ref<Texture2D> tex = base_mat->get_texture(BaseMaterial3D::TEXTURE_ALBEDO);
                        if (tex.is_valid() && !tex->get_path().is_empty()) {
                            mat_key = tex->get_path();
                        } else {
                            Color c = base_mat->get_albedo();
                            mat_key = UtilityFunctions::str("color_", c.r, "_", c.g, "_", c.b, "_", c.a);
                        }
                    }

                    if (mat_key.is_empty()) {
                        mat_key = mat->get_path();
                    }

                    if (!mat_key.is_empty()) {
                        if (material_dedup_map.has(mat_key)) {
                            mat = material_dedup_map[mat_key];
                        } else {
                            material_dedup_map[mat_key] = mat;
                        }
                    }
                }

                data.materials.write[i] = mat;
            }
        }

        data.valid = true;
        mesh_cache[scene_path] = data;

        inst->queue_free();
    }
}

BlockMeshData BlockMeshCache::get_block_mesh_data(const String &scene_path) {
    if (!mesh_cache.has(scene_path)) {
        preload_block_meshes();
    }
    if (mesh_cache.has(scene_path)) {
        return mesh_cache[scene_path];
    }
    return BlockMeshData();
}

void BlockMeshCache::clear_cache() {
    mesh_cache.clear();
}