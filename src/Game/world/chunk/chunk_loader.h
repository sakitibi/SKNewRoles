#pragma once

#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include "chunk_mesh_builder.h"

namespace godot {
    struct ChunkLoadData {
        Vector2i coord;
        String region_folder_path;
        float chunk_size = 16.0f;

        HashMap<String, Vector<Vector3>> categorized_positions;
        BuiltChunkData built_data;
        bool has_data = false;
        bool is_initial_load = false;
    };

    class ChunkLoader {
        public:
            static void async_load_worker(void *p_userdata);
            static Node3D *create_chunk_node(const Vector2i &coord, float chunk_size, const BuiltChunkData &built_data);
    };
}