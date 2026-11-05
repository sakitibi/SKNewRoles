#pragma once

#include <vector>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include "../../../../Blocks/block_mesh_cache.h"
#include "../chunk_mesh_builder.h"

namespace godot {

    struct Vector3iHash {
        std::size_t operator()(const Vector3i &v) const {
            std::size_t h1 = std::hash<int>()(v.x);
            std::size_t h2 = std::hash<int>()(v.y);
            std::size_t h3 = std::hash<int>()(v.z);
            return h1 ^ (h2 << 1) ^ (h3 << 2);
        }
    };

    class ChunkMeshProcessor {
    public:
        static PureChunkData process_chunk(
            const std::unordered_map<std::string, std::vector<Vector3>> &native_categorized
        );
    };
}