#include "chunk_queue_processor.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

ChunkQueueProcessor::ChunkQueueProcessor() {}

ChunkQueueProcessor::~ChunkQueueProcessor() {
    while (!completed_queue.empty()) {
        ChunkLoadData *data = completed_queue.front();
        completed_queue.pop();
        delete data;
    }
}

void ChunkQueueProcessor::push_completed_data(ChunkLoadData *data) {
    if (data) {
        completed_queue.push(data);
    }
}

bool ChunkQueueProcessor::is_queue_empty() const {
    return completed_queue.empty();
}

size_t ChunkQueueProcessor::get_queue_size() const {
    return completed_queue.size();
}

void ChunkQueueProcessor::process_queue(
    Node3D *parent_node,
    float chunk_size,
    HashMap<Vector2i, Node3D *> &loaded_chunks,
    HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map
) {
    if (!parent_node) return;

    int processed_count = 0;

    while (!completed_queue.empty() && processed_count < max_chunks_per_frame) {
        ChunkLoadData *data = completed_queue.front();
        completed_queue.pop();

        if (data) {
            Vector2i coord = data->coord;
            Node3D *chunk_node = ChunkLoader::create_chunk_node(coord, chunk_size, data->built_data);
            if (chunk_node) {
                parent_node->add_child(chunk_node);
                loaded_chunks[coord] = chunk_node;
                chunk_block_data_map[coord] = data->categorized_positions;
                UtilityFunctions::print(vformat("[ChunkQueueProcessor] Chunk (%d, %d) created and added to scene (queued).", coord.x, coord.y));
            }
            delete data;
        }

        processed_count++;
    }
}