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

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (data.is_empty() || palette_size <= 0) return 0;
    int block_index = y * 256 + z * 16 + x;
    int bits_per_block = std::max(4, (int)std::ceil(std::log2(palette_size)));
    int blocks_per_long = 64 / bits_per_block;
    int long_index = block_index / blocks_per_long;
    int bit_offset = (block_index % blocks_per_long) * bits_per_block;

    if (long_index >= data.size()) return 0;
    uint64_t mask = (1ULL << bits_per_block) - 1;
    return static_cast<int>((static_cast<uint64_t>(data[long_index]) >> bit_offset) & mask);
}

// 子ノードからマテリアルを取得
static Ref<Material> get_node_material(MeshInstance3D *mi, int surface_idx = 0) {
    if (!mi) return Ref<Material>();

    Ref<Material> mat = mi->get_material_override();
    if (mat.is_valid()) return mat;

    mat = mi->get_surface_override_material(surface_idx);
    if (mat.is_valid()) return mat;

    Ref<Mesh> mesh = mi->get_mesh();
    if (mesh.is_valid() && surface_idx < mesh->get_surface_count()) {
        mat = mesh->surface_get_material(surface_idx);
        if (mat.is_valid()) return mat;
    }

    return Ref<Material>();
}

// .tscn 内の QuadMesh を抽出してキャッシュ化
BlockMeshData ChunkMeshBuilder::get_block_mesh_data(const String &scene_path) {
    static HashMap<String, BlockMeshData> cache;
    if (cache.has(scene_path)) {
        return cache[scene_path];
    }

    BlockMeshData data;
    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    
    if (scene.is_valid()) {
        Node *inst = scene->instantiate();
        if (inst) {
            Node3D *node_3d = Object::cast_to<Node3D>(inst);
            if (node_3d) {
                Ref<ArrayMesh> combined_mesh;
                combined_mesh.instantiate();

                for (int i = 0; i < node_3d->get_child_count(); ++i) {
                    MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(node_3d->get_child(i));
                    if (!mi) continue;

                    Ref<Mesh> child_mesh = mi->get_mesh();
                    if (child_mesh.is_null() || child_mesh->get_surface_count() == 0) continue;

                    Ref<Material> mat = get_node_material(mi, 0);
                    if (mat.is_null()) {
                        Ref<StandardMaterial3D> default_mat;
                        default_mat.instantiate();
                        mat = default_mat;
                    }

                    Transform3D xform = mi->get_transform();
                    Array surf_arrays = child_mesh->surface_get_arrays(0);
                    PackedVector3Array vertices = surf_arrays[Mesh::ARRAY_VERTEX];
                    PackedVector3Array normals = surf_arrays[Mesh::ARRAY_NORMAL];

                    for (int v = 0; v < vertices.size(); ++v) {
                        vertices[v] = xform.xform(vertices[v]);
                        if (v < normals.size()) {
                            normals[v] = xform.basis.xform(normals[v]).normalized();
                        }
                    }
                    surf_arrays[Mesh::ARRAY_VERTEX] = vertices;
                    surf_arrays[Mesh::ARRAY_NORMAL] = normals;

                    int new_surf_idx = combined_mesh->get_surface_count();
                    combined_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, surf_arrays);
                    combined_mesh->surface_set_material(new_surf_idx, mat);

                    data.materials.push_back(mat);
                }

                if (combined_mesh->get_surface_count() > 0) {
                    data.mesh = combined_mesh;
                    data.valid = true;
                }
            }
            memdelete(inst);
        }
    }

    if (!data.valid || data.mesh.is_null()) {
        Ref<BoxMesh> box;
        box.instantiate();
        box->set_size(Vector3(1.0f, 1.0f, 1.0f));

        Ref<StandardMaterial3D> fallback_mat;
        fallback_mat.instantiate();

        data.mesh = box;
        data.materials.push_back(fallback_mat);
        data.valid = true;
    }

    cache[scene_path] = data;
    return data;
}

// MultiMesh (描画用)
void ChunkMeshBuilder::build_multimesh_for_block(Node3D *parent_node, const String &scene_path, const Vector<Vector3> &positions) {
    if (positions.is_empty() || parent_node == nullptr) return;

    BlockMeshData mesh_data = get_block_mesh_data(scene_path);
    if (mesh_data.mesh.is_null()) return;

    Ref<MultiMesh> multimesh;
    multimesh.instantiate();
    multimesh->set_transform_format(MultiMesh::TRANSFORM_3D);
    multimesh->set_mesh(mesh_data.mesh);
    multimesh->set_instance_count(positions.size());

    for (int i = 0; i < positions.size(); ++i) {
        Transform3D t;
        t.origin = positions[i];
        multimesh->set_instance_transform(i, t);
    }

    MultiMeshInstance3D *mm_node = memnew(MultiMeshInstance3D);
    mm_node->set_multimesh(multimesh);
    parent_node->add_child(mm_node);
}

void ChunkMeshBuilder::build_mesh_and_collision(Node3D *parent_node, const Array &sections) {
    if (!parent_node) return;

    const HashMap<String, String> &block_map = get_block_scene_map();
    HashMap<String, Vector<Vector3>> categorized_positions;

    // 各セクションからブロック座標を抽出
    for (int s = 0; s < sections.size(); ++s) {
        Dictionary section = sections[s];
        if (!section.has("block_states")) continue;

        Dictionary block_states = section["block_states"];
        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        int section_y = section.has("Y") ? (int)section["Y"] : 0;
        PackedInt64Array data = block_states.has("data") ? (PackedInt64Array)block_states["data"] : PackedInt64Array();

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_index = get_palette_index(data, palette.size(), x, y, z);
                    if (p_index < 0 || p_index >= palette.size()) continue;

                    Dictionary block_type = palette[p_index];
                    String name = block_type.has("Name") ? (String)block_type["Name"] : "";

                    if (name == "minecraft:air" || name.is_empty() || !block_map.has(name)) {
                        continue;
                    }

                    Vector3 block_pos(x, section_y * 16 + y, z);
                    categorized_positions[name].push_back(block_pos);
                }
            }
        }
    }

    // 描画用の MultiMeshInstance3D を生成（見た目の描画）
    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;
        build_multimesh_for_block(parent_node, block_name, positions);
    }

    PackedVector3Array collision_faces;

    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        BlockMeshData mesh_data = get_block_mesh_data(block_map[block_name]);
        if (mesh_data.mesh.is_null()) continue;

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
        concave_shape->set_faces(collision_faces); // 全頂点を設定

        col_shape->set_shape(concave_shape);
        static_body->add_child(col_shape);

        parent_node->add_child(static_body);
    }
}