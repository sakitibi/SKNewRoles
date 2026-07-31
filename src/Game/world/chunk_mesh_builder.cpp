#include "chunk_mesh_builder.h"
#include "chunk_collision_builder.h"
#include "../../Blocks/block_registry.h"
#include "../../Blocks/block_mesh_cache.h"

#include <godot_cpp/classes/multi_mesh_instance3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/templates/hash_set.hpp>

#include <vector>
#include <algorithm>

using namespace godot;

ChunkMeshBuilder::ChunkMeshBuilder() {}
ChunkMeshBuilder::~ChunkMeshBuilder() {}

void ChunkMeshBuilder::_bind_methods() {
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (palette_size <= 1) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = y * 256 + z * 16 + x;
    int entries_per_long = 64 / bits_per_entry;
    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index < 0 || long_index >= data.size()) return 0;

    uint64_t raw_long = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1;
    return static_cast<int>((raw_long >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(
    const Dictionary &chunk_data,
    int min_section_y,
    int max_section_y
) {
    HashMap<String, Vector<Vector3>> categorized_positions;
    if (!chunk_data.has("sections")) return categorized_positions;

    Array sections = chunk_data["sections"];

    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int section_y = section["Y"];
        if (section_y < min_section_y || section_y > max_section_y) continue;

        Dictionary block_states = section["block_states"];
        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        PackedInt64Array data_array;
        if (block_states.has("data")) {
            data_array = block_states["data"];
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = 0;
                    if (!data_array.is_empty()) {
                        p_idx = get_palette_index(data_array, palette.size(), x, y, z);
                    }

                    if (p_idx >= 0 && p_idx < palette.size()) {
                        Dictionary b_entry = palette[p_idx];
                        String block_name = b_entry.get("Name", "minecraft:air");

                        // BlockRegistry::has_block を静的に呼び出し
                        if (block_name != "minecraft:air" && BlockRegistry::has_block(block_name)) {
                            Vector3 pos(x, section_y * 16 + y, z);
                            categorized_positions[block_name].append(pos);
                        }
                    }
                }
            }
        }
    }

    return categorized_positions;
}

BuiltChunkData ChunkMeshBuilder::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions,
    bool p_is_initial_load
) {
    BuiltChunkData result;

    HashSet<Vector3i> occupied_blocks;
    for (const auto &E : categorized_positions) {
        for (const Vector3 &pos : E.value) {
            occupied_blocks.insert(Vector3i(
                static_cast<int>(std::floor(pos.x)),
                static_cast<int>(std::floor(pos.y)),
                static_cast<int>(std::floor(pos.z))
            ));
        }
    }

    const HashMap<String, String> &registry_map = BlockRegistry::get_block_scene_map();

    for (const auto &E : categorized_positions) {
        String block_id = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!registry_map.has(block_id)) continue;

        String scene_path = registry_map[block_id];

        // 遮蔽カリング（完全に囲まれたブロックを判定して除外）
        Vector<Vector3> visible_positions;
        for (const Vector3 &pos : positions) {
            Vector3i grid_pos(
                static_cast<int>(std::floor(pos.x)),
                static_cast<int>(std::floor(pos.y)),
                static_cast<int>(std::floor(pos.z))
            );

            bool is_fully_surrounded =
                occupied_blocks.has(grid_pos + Vector3i(1, 0, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(-1, 0, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, 1, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, -1, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, 0, 1)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, 0, -1));

            if (!is_fully_surrounded) {
                visible_positions.append(pos);
            }
        }

        int visible_count = visible_positions.size();
        if (visible_count == 0) continue;

        BlockMeshData mesh_data = BlockMeshCache::get_block_mesh_data(scene_path);

        if (mesh_data.valid) {
            Ref<MultiMesh> multimesh;
            multimesh.instantiate();
            multimesh->set_transform_format(MultiMesh::TRANSFORM_3D);
            multimesh->set_mesh(mesh_data.mesh);
            multimesh->set_instance_count(visible_count);

            for (int i = 0; i < visible_count; ++i) {
                Transform3D t;
                t.origin = visible_positions[i] + Vector3(0.5f, 0.5f, 0.5f);
                multimesh->set_instance_transform(i, t);
            }
            result.multimeshes[block_id] = multimesh;
        }
    }

    result.collision_faces = ChunkCollisionBuilder::build_collision_faces(categorized_positions);

    return result;
}

void ChunkMeshBuilder::apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkData &built_data) {
    if (!parent_node) return;

    for (const auto &E : built_data.multimeshes) {
        MultiMeshInstance3D *mmi = memnew(MultiMeshInstance3D);
        mmi->set_multimesh(E.value);
        parent_node->add_child(mmi);
    }

    if (built_data.collision_faces.size() > 0) {
        StaticBody3D *static_body = memnew(StaticBody3D);
        static_body->set_name("ChunkStaticBody");

        CollisionShape3D *collision_shape = memnew(CollisionShape3D);
        Ref<ConcavePolygonShape3D> concave_shape;
        concave_shape.instantiate();
        concave_shape->set_faces(built_data.collision_faces);

        collision_shape->set_shape(concave_shape);
        static_body->add_child(collision_shape);

        parent_node->add_child(static_body);
    }
}