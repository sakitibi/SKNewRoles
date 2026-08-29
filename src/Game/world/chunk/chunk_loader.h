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

        // チャンク相対高度
        float chunk_height = 256.0f;   // 1チャンクの相対的な高さ
        float base_y_position = 0.0f;  // 基準Y座標（オフセット）

        // ワールド絶対高度制限
        float min_height = -64.0f;     // ワールド全体の最小Y座標
        float max_height = 320.0f;     // ワールド全体の最大Y座標

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