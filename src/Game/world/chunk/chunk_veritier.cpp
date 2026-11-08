#include "chunk_veritier.h"
#include <chrono>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkVeritier::verity_initial_collisions(const HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map) {
    auto start_time = std::chrono::high_resolution_clock::now();

    UtilityFunctions::print("[ChunkManager Veritication] --- Block Data & Collision Source Veritication ---");

    int total_chunks = chunk_block_data_map.size();
    int total_blocks = 0;

    for (const auto &E : chunk_block_data_map) {
        const HashMap<String, Vector<Vector3>> &block_map = E.value;
        for (const auto &subE : block_map) {
            total_blocks += subE.value.size();
        }
    }

    UtilityFunctions::print(vformat("[ChunkManager Veritication] Loaded chunks count: %d", total_chunks));
    UtilityFunctions::print(vformat("[ChunkManager Veritication] Total registered block positions: %d", total_blocks));

    if (total_blocks == 0) {
        UtilityFunctions::printerr("[ChunkManager ERROR] There are zero block data positions! Collision generation will fail because no blocks were parsed!");
    } else {
        UtilityFunctions::print("[ChunkManager Veritication] SUCCESS: Block data exists and is ready for collision generation.");
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
    UtilityFunctions::print(vformat("Chunk data veritication time: %d ms", (int)duration_ms));
}