#include "chunk_mesh_builder.h"
#include <godot_cpp/core/memory.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <cmath>
#include <algorithm>

using namespace godot;

// ブロック名とシーンプレハブ (.tscn) の対応表
const HashMap<String, String>& ChunkMeshBuilder::get_block_scene_map() {
    static HashMap<String, String> map;
    if (map.is_empty()) {
        map["minecraft:grass_block"]   = "res://Scenes/Prefabs/Blocks/GrassBlock.tscn";
        map["minecraft:stone"]         = "res://Scenes/Prefabs/Blocks/Stone.tscn";
        map["minecraft:stone_bricks"]  = "res://Scenes/Prefabs/Blocks/StoneBricks.tscn";
        map["minecraft:gold_block"]    = "res://Scenes/Prefabs/Blocks/GoldBlock.tscn";
        map["minecraft:dirt"]          = "res://Scenes/Prefabs/Blocks/GrassBlock.tscn";
    }
    return map;
}

// 起動時のリソース事前ロード
void ChunkMeshBuilder::preload_block_meshes() {
    const HashMap<String, String> &map = get_block_scene_map();
    for (const auto &E : map) {
        get_block_mesh_data(E.value);
    }
}

BlockMeshData ChunkMeshBuilder::get_block_mesh_data(const String &scene_path) {
    static HashMap<String, BlockMeshData> cache;
    if (cache.has(scene_path)) {
        return cache[scene_path];
    }

    BlockMeshData res;
    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    if (scene.is_valid()) {
        Node *inst = scene->instantiate();
        if (inst) {
            MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(inst);
            if (!mi) {
                Node *child = inst->find_child("*", true, false);
                if (child) {
                    mi = Object::cast_to<MeshInstance3D>(child);
                }
            }

            if (mi && mi->get_mesh().is_valid()) {
                res.mesh = mi->get_mesh();
                for (int s = 0; s < res.mesh->get_surface_count(); ++s) {
                    res.materials.push_back(mi->get_surface_override_material(s));
                }
                res.valid = true;
            }
            memdelete(inst);
        }
    }

    cache[scene_path] = res;
    return res;
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (data.is_empty() || palette_size <= 0) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = y * 256 + z * 16 + x;
    int entries_per_long = 64 / bits_per_entry;
    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index < 0 || long_index >= data.size()) return 0;

    uint64_t long_val = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1ULL;
    return static_cast<int>((long_val >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::extract_block_positions(const Array &sections) {
    HashMap<String, Vector<Vector3>> categorized_positions;
    const HashMap<String, String> &block_map = get_block_scene_map();

    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int sec_y = section["Y"];
        Dictionary block_states = section["block_states"];

        if (!block_states.has("palette")) continue;
        Array palette = block_states["palette"];

        PackedInt64Array data;
        if (block_states.has("data")) {
            data = block_states["data"];
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = 0;
                    if (palette.size() > 1) {
                        p_idx = get_palette_index(data, palette.size(), x, y, z);
                    }

                    if (p_idx >= 0 && p_idx < palette.size()) {
                        Dictionary block = palette[p_idx];
                        String block_name = block.get("Name", "minecraft:air");

                        if (block_map.has(block_name)) {
                            Vector3 pos(x, sec_y * 16 + y, z);
                            categorized_positions[block_name].push_back(pos);
                        }
                    }
                }
            }
        }
    }

    return categorized_positions;
}

void ChunkMeshBuilder::build_from_positions(Node3D *parent_node, const HashMap<String, Vector<Vector3>> &categorized_positions) {
    const HashMap<String, String> &block_map = get_block_scene_map();
    PackedVector3Array collision_faces;

    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!block_map.has(block_name) || positions.is_empty()) continue;

        String scene_path = block_map[block_name];
        BlockMeshData mesh_data = get_block_mesh_data(scene_path);
        
        if (!mesh_data.valid || mesh_data.mesh.is_null()) continue;

        MultiMeshInstance3D *mmi = memnew(MultiMeshInstance3D);
        Ref<MultiMesh> mm;
        mm.instantiate();

        mm->set_transform_format(MultiMesh::TRANSFORM_3D);
        mm->set_mesh(mesh_data.mesh);
        mm->set_instance_count(positions.size());

        for (int i = 0; i < positions.size(); ++i) {
            Transform3D t;
            t.origin = positions[i];
            mm->set_instance_transform(i, t);
        }

        mmi->set_multimesh(mm);

        // マテリアル適用
        for (int s = 0; s < mesh_data.materials.size(); ++s) {
            if (!mesh_data.materials.is_empty() && mesh_data.materials[0].is_valid()) {
                mmi->set_material_override(mesh_data.materials[0]);
            }
        }

        parent_node->add_child(mmi);

        for (int s = 0; s < mesh_data.mesh->get_surface_count(); ++s) {
            Array surf_arrays = mesh_data.mesh->surface_get_arrays(s);
            if (surf_arrays.size() <= Mesh::ARRAY_VERTEX) continue;

            PackedVector3Array verts = surf_arrays[Mesh::ARRAY_VERTEX];
            PackedInt32Array indices = surf_arrays[Mesh::ARRAY_INDEX];

            for (int i = 0; i < positions.size(); ++i) {
                Vector3 block_pos = positions[i];

                if (indices.size() > 0) {
                    for (int idx = 0; idx < indices.size(); ++idx) {
                        collision_faces.append(verts[indices[idx]] + block_pos);
                    }
                } else {
                    for (int v = 0; v < verts.size(); ++v) {
                        collision_faces.append(verts[v] + block_pos);
                    }
                }
            }
        }
    }

    if (collision_faces.size() > 0) {
        StaticBody3D *static_body = memnew(StaticBody3D);
        static_body->set_collision_layer(1);
        static_body->set_collision_mask(1);

        CollisionShape3D *col_shape = memnew(CollisionShape3D);
        Ref<ConcavePolygonShape3D> concave_shape;
        concave_shape.instantiate();
        concave_shape->set_faces(collision_faces);

        col_shape->set_shape(concave_shape);
        static_body->add_child(col_shape);

        parent_node->add_child(static_body);
    }
}