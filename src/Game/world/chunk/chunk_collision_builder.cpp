#include "chunk_collision_builder.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>
#include <chrono>
#include <vector>
#include <string>
#include <unordered_map>
#include <unordered_set>

using namespace godot;

struct CollisionVector3iHash {
    std::size_t operator()(const Vector3i &v) const {
        std::size_t h1 = std::hash<int>()(v.x);
        std::size_t h2 = std::hash<int>()(v.y);
        std::size_t h3 = std::hash<int>()(v.z);
        return h1 ^ (h2 << 1) ^ (h3 << 2);
    }
};

static inline Vector3i to_grid_pos(const Vector3 &v) {
    return Vector3i(
        static_cast<int>(std::round(v.x)),
        static_cast<int>(std::round(v.y)),
        static_cast<int>(std::round(v.z))
    );
}

PackedVector3Array ChunkCollisionBuilder::build_collision_faces(
    const HashMap<String, Vector<Vector3>> &categorized_positions
) {
    auto start_time = std::chrono::high_resolution_clock::now();

    UtilityFunctions::print(vformat("[ChunkCollisionBuilder] Received categorized_positions size: %d", categorized_positions.size()));

    std::unordered_map<std::string, std::vector<Vector3>> native_categorized;
    native_categorized.reserve(categorized_positions.size());

    size_t total_positions_count = 0;
    for (const auto &E : categorized_positions) {
        std::string b_id = std::string(E.key.utf8().get_data());
        const Vector<Vector3> &godot_vec = E.value;
        
        UtilityFunctions::print(vformat("[ChunkCollisionBuilder] Block ID: %s, Count: %d", E.key, godot_vec.size()));

        std::vector<Vector3> vec;
        vec.reserve(godot_vec.size());
        for (int i = 0; i < godot_vec.size(); ++i) {
            vec.push_back(godot_vec[i]);
        }
        total_positions_count += vec.size();
        if (!vec.empty()) {
            native_categorized[b_id] = std::move(vec);
        }
    }

    UtilityFunctions::print(vformat("[ChunkCollisionBuilder] Total positions count: %d", (int)total_positions_count));

    std::unordered_set<Vector3i, CollisionVector3iHash> occupied_blocks;
    occupied_blocks.reserve(total_positions_count);

    std::vector<Vector3> all_positions;
    all_positions.reserve(total_positions_count);

    for (const auto &pair : native_categorized) {
        for (const Vector3 &pos : pair.second) {
            Vector3i grid_pos = to_grid_pos(pos);
            occupied_blocks.insert(grid_pos);
            all_positions.push_back(pos);
        }
    }

    static const Vector3 box_verts[36] = {
        // Top (+Y)
        Vector3(-0.5f, 0.5f, -0.5f), Vector3(0.5f, 0.5f, -0.5f), Vector3(0.5f, 0.5f, 0.5f),
        Vector3(-0.5f, 0.5f, -0.5f), Vector3(0.5f, 0.5f, 0.5f), Vector3(-0.5f, 0.5f, 0.5f),
        // Bottom (-Y)
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(0.5f, -0.5f, 0.5f), Vector3(0.5f, -0.5f, -0.5f),
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(0.5f, -0.5f, -0.5f), Vector3(-0.5f, -0.5f, -0.5f),
        // Front (+Z)
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(-0.5f, 0.5f, 0.5f), Vector3(0.5f, 0.5f, 0.5f),
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(0.5f, 0.5f, 0.5f), Vector3(0.5f, -0.5f, 0.5f),
        // Back (-Z)
        Vector3(0.5f, -0.5f, -0.5f), Vector3(0.5f, 0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f),
        Vector3(0.5f, -0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f), Vector3(-0.5f, -0.5f, -0.5f),
        // Left (-X)
        Vector3(-0.5f, -0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f), Vector3(-0.5f, 0.5f, 0.5f),
        Vector3(-0.5f, -0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f), Vector3(-0.5f, -0.5f, 0.5f),
        // Right (+X)
        Vector3(0.5f, -0.5f, 0.5f), Vector3(0.5f, 0.5f, 0.5f), Vector3(0.5f, 0.5f, -0.5f),
        Vector3(0.5f, -0.5f, 0.5f), Vector3(0.5f, 0.5f, -0.5f), Vector3(0.5f, -0.5f, -0.5f)
    };

    std::vector<Vector3> native_collision_faces;
    native_collision_faces.reserve(all_positions.size() * 36);

    for (const Vector3 &pos : all_positions) {
        /*
        bool is_fully_surrounded =
            (occupied_blocks.find(grid_pos + Vector3i(1, 0, 0)) != occupied_blocks.end()) &&
            (occupied_blocks.find(grid_pos + Vector3i(-1, 0, 0)) != occupied_blocks.end()) &&
            (occupied_blocks.find(grid_pos + Vector3i(0, 1, 0)) != occupied_blocks.end()) &&
            (occupied_blocks.find(grid_pos + Vector3i(0, -1, 0)) != occupied_blocks.end()) &&
            (occupied_blocks.find(grid_pos + Vector3i(0, 0, 1)) != occupied_blocks.end()) &&
            (occupied_blocks.find(grid_pos + Vector3i(0, 0, -1)) != occupied_blocks.end());

        if (is_fully_surrounded) continue;
        */

        Vector3 offset(pos.x + 0.5f, pos.y + 0.5f, pos.z + 0.5f);
        for (int k = 0; k < 36; ++k) {
            native_collision_faces.push_back(box_verts[k] + offset);
        }
    }

    PackedVector3Array collision_faces;
    collision_faces.resize(native_collision_faces.size());
    if (!native_collision_faces.empty()) {
        std::memcpy(collision_faces.ptrw(), native_collision_faces.data(), native_collision_faces.size() * sizeof(Vector3));
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
    UtilityFunctions::print(vformat("Chunk collision build time (Native STL): %d ms, Polygons: %d", (int)duration_ms, (int)(collision_faces.size() / 3)));

    return collision_faces;
}