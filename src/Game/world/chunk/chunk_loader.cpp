#include "chunk_loader.h"
#include "../mca_parser.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkLoader::async_load_worker(void *p_userdata) {
    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data) return;

    // MCAからパースした生のブロック位置を取得
    HashMap<String, Vector<Vector3>> raw_positions = ChunkMeshBuilder::parse_chunk_positions(
        MCAParser::parse_chunk(data->region_folder_path, data->coord.x, data->coord.y)
    );

    // 高度制限（相対 ＆ 絶対）のフィルタリング処理
    HashMap<String, Vector<Vector3>> filtered_positions;

    for (const KeyValue<String, Vector<Vector3>> &entry : raw_positions) {
        String block_type = entry.key;
        const Vector<Vector3> &pos_list = entry.value;

        Vector<Vector3> valid_positions;
        for (int i = 0; i < pos_list.size(); ++i) {
            Vector3 block_pos = pos_list[i];

            float local_y = block_pos.y;
            if (local_y < 0.0f || local_y >= data->chunk_height) {
                continue;
            }

            float world_y = data->base_y_position + local_y;
            if (world_y < data->min_height || world_y > data->max_height) {
                continue;
            }

            valid_positions.push_back(block_pos);
        }

        if (valid_positions.size() > 0) {
            filtered_positions[block_type] = valid_positions;
        }
    }

    data->categorized_positions = filtered_positions;

    // メッシュ生成処理へ渡す
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