#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/variant/string.hpp>
#include <queue>

#include "chunk_loader.h"

namespace godot {
    class ChunkQueueProcessor {
        private:
            std::queue<ChunkLoadData *> completed_queue;
            int max_chunks_per_frame = 1;

        public:
            ChunkQueueProcessor();
            ~ChunkQueueProcessor();

            void push_completed_data(ChunkLoadData *data);
            bool is_queue_empty() const;
            size_t get_queue_size() const;

            void process_queue(
                Node3D *parent_node,
                float chunk_size,
                HashMap<Vector2i, Node3D *> &loaded_chunks,
                HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map
            );

            void set_max_chunks_per_frame(int max_chunks) { max_chunks_per_frame = max_chunks; }
            int get_max_chunks_per_frame() const { return max_chunks_per_frame; }
    };
}