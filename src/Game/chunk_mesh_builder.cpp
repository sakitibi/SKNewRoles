#include "chunk_mesh_builder.h"
#include <cmath>
#include <algorithm>

using namespace godot;

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

void ChunkMeshBuilder::build_mesh_and_collision(Node3D *parent_node, const Dictionary &chunk_nbt) {
    if (parent_node == nullptr || chunk_nbt.is_empty()) return;

    Dictionary root = chunk_nbt.get("", Dictionary());
    if (!root.has("sections")) return;

    Array sections = root["sections"];

    PackedVector3Array vertices;
    PackedVector3Array normals;
    PackedInt32Array indices;

    int vertex_count = 0;

    // 立方体6面の法線ベクトル
    const Vector3 face_normals[6] = {
        Vector3(0, 1, 0),  Vector3(0, -1, 0), Vector3(0, 0, 1),
        Vector3(0, 0, -1), Vector3(-1, 0, 0), Vector3(1, 0, 0)
    };

    // 6面それぞれのローカル頂点位置（1x1x1のボクセル）
    const Vector3 face_vertices[6][4] = {
        { Vector3(0,1,1), Vector3(1,1,1), Vector3(1,1,0), Vector3(0,1,0) }, // Top (+Y)
        { Vector3(0,0,0), Vector3(1,0,0), Vector3(1,0,1), Vector3(0,0,1) }, // Bottom (-Y)
        { Vector3(0,0,1), Vector3(1,0,1), Vector3(1,1,1), Vector3(0,1,1) }, // Front (+Z)
        { Vector3(1,0,0), Vector3(0,0,0), Vector3(0,1,0), Vector3(1,1,0) }, // Back (-Z)
        { Vector3(0,0,0), Vector3(0,0,1), Vector3(0,1,1), Vector3(0,1,0) }, // Left (-X)
        { Vector3(1,0,1), Vector3(1,0,0), Vector3(1,1,0), Vector3(1,1,1) }  // Right (+X)
    };

    // 各16x16x16セクションをループ処理
    for (int s = 0; s < sections.size(); ++s) {
        Dictionary section = sections[s];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int section_y = (int)section["Y"];
        Dictionary block_states = section["block_states"];
        if (!block_states.has("palette") || !block_states.has("data")) continue;

        Array palette = block_states["palette"];
        PackedInt64Array data = block_states["data"];
        int palette_size = palette.size();

        for (int x = 0; x < 16; ++x) {
            for (int y = 0; y < 16; ++y) {
                for (int z = 0; z < 16; ++z) {
                    int p_idx = get_palette_index(data, palette_size, x, y, z);
                    if (p_idx < 0 || p_idx >= palette.size()) continue;

                    Dictionary b_state = palette[p_idx];
                    String b_name = b_state.get("Name", "minecraft:air");
                    if (b_name == "minecraft:air") continue; // 空気ブロックは無視

                    Vector3 block_pos(x, section_y * 16 + y, z);

                    // 6面分のポリゴン頂点を結合
                    for (int f = 0; f < 6; ++f) {
                        for (int v = 0; v < 4; ++v) {
                            vertices.append(block_pos + face_vertices[f][v]);
                            normals.append(face_normals[f]);
                        }

                        // ポリゴンインデックス（2つの三角形で1面を作る）
                        indices.append(vertex_count + 0);
                        indices.append(vertex_count + 1);
                        indices.append(vertex_count + 2);
                        indices.append(vertex_count + 0);
                        indices.append(vertex_count + 2);
                        indices.append(vertex_count + 3);

                        vertex_count += 4;
                    }
                }
            }
        }
    }

    if (vertices.is_empty()) return;

    // 1. メッシュの構築
    Array mesh_array;
    mesh_array.resize(Mesh::ARRAY_MAX);
    mesh_array[Mesh::ARRAY_VERTEX] = vertices;
    mesh_array[Mesh::ARRAY_NORMAL] = normals;
    mesh_array[Mesh::ARRAY_INDEX] = indices;

    Ref<ArrayMesh> array_mesh;
    array_mesh.instantiate();
    array_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, mesh_array);

    // 描画ノード作成
    MeshInstance3D *mesh_instance = memnew(MeshInstance3D);
    mesh_instance->set_mesh(array_mesh);
    parent_node->add_child(mesh_instance);

    // 2. アタリ判定（コリジョン）の同一メッシュ結合作成
    StaticBody3D *static_body = memnew(StaticBody3D);
    CollisionShape3D *col_shape = memnew(CollisionShape3D);
    Ref<ConcavePolygonShape3D> polygon_shape;
    polygon_shape.instantiate();
    polygon_shape->set_faces(array_mesh->get_faces());

    col_shape->set_shape(polygon_shape);
    static_body->add_child(col_shape);
    parent_node->add_child(static_body);
}