#include "chunk_loader.h"
#include "../mca_parser.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkLoader::async_load_worker(void *p_userdata) {
    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data) return;

    data->categorized_positions = ChunkMeshBuilder::parse_chunk_positions(
        MCAParser::parse_chunk(data->region_folder_path, data->coord.x, data->coord.y)
    );

    data->built_data = ChunkMeshBuilder::build_chunk_data_async(
        data->categorized_positions,
        data->is_initial_load
    );
    data->has_data = true;
}

Node3D *ChunkLoader::create_chunk_node(const Vector2i &coord, float chunk_size, const BuiltChunkData &built_data) {
    Node3D *chunk_node = memnew(Node3D);
    chunk_node->set_name(vformat("Chunk_%d_%d", coord.x, coord.y));

    Vector3 pos(coord.x * chunk_size, 0.0f, coord.y * chunk_size);
    chunk_node->set_position(pos);

    ChunkMeshBuilder::apply_chunk_data_to_node(chunk_node, built_data);
    return chunk_node;
}