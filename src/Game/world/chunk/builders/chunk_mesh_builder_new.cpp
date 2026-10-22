#include "chunk_mesh_builder_new.h"
#include "../chunk_collision_builder.h"
#include "../../cube_mesh_utils.h"
#include "../../../../Blocks/block_registry.h"
#include "../../../../Blocks/block_mesh_cache.h"

#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>
#include <chrono>

using namespace godot;

static inline Vector3i to_grid_pos(const Vector3 &v) {
    return Vector3i(
        static_cast<int>(std::round(v.x)),
        static_cast<int>(std::round(v.y)),
        static_cast<int>(std::round(v.z))
    );
}

static inline bool is_dirt_path_id(const String &block_id) {
    return block_id == "minecraft:dirt_path" ||
        block_id.contains("dirt_path") ||
        block_id.contains("DirtPath");
}

static Ref<Material> resolve_face_material(const BlockMeshData &mesh_data, int face_index) {
    if (!mesh_data.valid || mesh_data.materials.is_empty()) {
        return Ref<Material>();
    }

    int mat_count = mesh_data.materials.size();

    if (mat_count == 1) {
        return mesh_data.materials[0];
    }

    if (face_index >= 0 && face_index < mat_count && mesh_data.materials[face_index].is_valid()) {
        return mesh_data.materials[face_index];
    }

    if (mesh_data.materials[0].is_valid()) {
        return mesh_data.materials[0];
    }

    return Ref<Material>();
}

PureChunkData ChunkMeshBuilderNew::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions,
    bool p_is_initial_load
) {
    auto start_time = std::chrono::high_resolution_clock::now();

    PureChunkData result;

    HashSet<Vector3i> occupied_blocks;
    HashSet<Vector3i> dirt_path_blocks;

    for (const auto &E : categorized_positions) {
        bool is_dirt_path = is_dirt_path_id(E.key);
        for (const Vector3 &pos : E.value) {
            Vector3i grid_pos = to_grid_pos(pos);
            occupied_blocks.insert(grid_pos);
            if (is_dirt_path) {
                dirt_path_blocks.insert(grid_pos);
            }
        }
    }

    const HashMap<String, String> &registry_map = BlockRegistry::get_block_scene_map();

    for (const auto &E : categorized_positions) {
        String block_id = E.key;
        const Vector<Vector3> &positions = E.value;

        String lookup_id = block_id.replace("minecraft:", "");
        String scene_path = "";

        if (registry_map.has(block_id)) {
            scene_path = registry_map[block_id];
        } else if (registry_map.has(lookup_id)) {
            scene_path = registry_map[lookup_id];
        } else if (registry_map.has("default")) {
            scene_path = registry_map["default"];
        }

        float height = is_dirt_path_id(block_id) ? 0.938f : 1.0f;

        Vector<CubeFaceData> faces = CubeMeshUtils::get_cube_faces(height);
        BlockMeshData mesh_data = BlockMeshCache::get_block_mesh_data(scene_path);

        std::unordered_map<Material*, PureSurfaceData> surface_map;

        for (const Vector3 &pos : positions) {
            Vector3i grid_pos = to_grid_pos(pos);

            for (int f = 0; f < 6; ++f) {
                const CubeFaceData &face = faces[f];
                Vector3i neighbor_pos = grid_pos + face.dir;

                if (occupied_blocks.has(neighbor_pos) && !dirt_path_blocks.has(neighbor_pos)) {
                    continue;
                }

                Ref<Material> face_mat = resolve_face_material(mesh_data, f);

                if (face_mat.is_null()) {
                    face_mat = BlockMeshCache::get_default_material();
                }

                if (face_mat.is_null()) {
                    continue;
                }

                Material* mat_ptr = face_mat.ptr();
                PureSurfaceData &surf = surface_map[mat_ptr];
                surf.material = face_mat;

                int base_idx = surf.vertex_count;
                for (int v = 0; v < 4; ++v) {
                    surf.vertices.push_back(pos + face.vertices[v]);
                    surf.normals.push_back(face.normal);
                    surf.uvs.push_back(face.uvs[v]);
                }

                surf.indices.push_back(base_idx + 0);
                surf.indices.push_back(base_idx + 1);
                surf.indices.push_back(base_idx + 2);
                surf.indices.push_back(base_idx + 0);
                surf.indices.push_back(base_idx + 2);
                surf.indices.push_back(base_idx + 3);

                surf.vertex_count += 4;
            }
        }

        if (surface_map.empty()) continue;

        std::vector<PureSurfaceData> surfaces_list;
        for (const auto &S : surface_map) {
            if (!S.second.vertices.empty()) {
                surfaces_list.push_back(S.second);
            }
        }

        if (!surfaces_list.empty()) {
            result.block_surfaces[block_id.utf8().get_data()] = surfaces_list;
        }
    }

    result.collision_faces = ChunkCollisionBuilder::build_collision_faces(categorized_positions);

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();

    UtilityFunctions::print(vformat("Chunk build new time: %d ms", (int)duration_ms));

    return result;
}