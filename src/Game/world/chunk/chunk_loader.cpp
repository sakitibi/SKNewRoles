#include "chunk_loader.h"
#include "../nbt/mca_parser.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <chrono>

using namespace godot;

void ChunkLoader::async_load_worker(void *p_userdata) {
    auto start_time = std::chrono::high_resolution_clock::now();

    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data) return;

    Dictionary chunk_data = MCAParser::parse_chunk(data->region_folder_path, data->coord.x, data->coord.y);
    if (chunk_data.is_empty()) {
        data->has_data = true;
        return;
    }

    HashMap<String, Vector<Vector3>> raw_positions = ChunkMeshBuilder::parse_chunk_positions(chunk_data);

    HashMap<String, Vector<Vector3>> filtered_positions;
    HashMap<Vector3, String> block_biomes;

    Array sections;
    sections = chunk_data["sections"];

    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("Y") && !section.has("y")) continue;
        
        int section_y = section.has("Y") ? static_cast<int>(section["Y"]) : static_cast<int>(section["y"]);
        if (section_y > 127) section_y -= 256; // 負のセクション座標対応

        if (section.has("biomes") || section.has("Biomes")) {
            Dictionary biomes_dict = section.has("biomes") ? section["biomes"] : section["Biomes"];
            
            if (biomes_dict.has("palette") || biomes_dict.has("Palette")) {
                Array biome_palette = biomes_dict.has("palette") ? biomes_dict["palette"] : biomes_dict["Palette"];
                PackedInt64Array biome_data_array;
                
                if (biomes_dict.has("data")) {
                    biome_data_array = biomes_dict["data"];
                } else if (biomes_dict.has("Data")) {
                    biome_data_array = biomes_dict["Data"];
                }

                for (int y = 0; y < 16; ++y) {
                    for (int z = 0; z < 16; ++z) {
                        for (int x = 0; x < 16; ++x) {
                            int bx = x / 4;
                            int by = y / 4;
                            int bz = z / 4;
                            int b_idx = by * 16 + bz * 4 + bx;

                            int palette_idx = 0;
                            if (!biome_data_array.is_empty() && b_idx >= 0 && b_idx < biome_data_array.size()) {
                                palette_idx = static_cast<int>(biome_data_array[b_idx]);
                            }

                            if (palette_idx >= 0 && palette_idx < biome_palette.size()) {
                                Dictionary b_entry = biome_palette[palette_idx];
                                String biome_name = b_entry.get("Name", b_entry.get("name", "minecraft:plains"));
                                
                                float world_y = static_cast<float>(section_y * 16 + y);
                                Vector3 block_pos(static_cast<float>(x), world_y, static_cast<float>(z));
                                
                                // ブロック位置ごとにバイオームを紐付け
                                block_biomes[block_pos] = biome_name;
                            }
                        }
                    }
                }
            }
        }
    }

    for (const KeyValue<String, Vector<Vector3>> &entry : raw_positions) {
        String block_type = entry.key;
        const Vector<Vector3> &pos_list = entry.value;
        int size = pos_list.size();

        if (size == 0) continue;

        Vector<Vector3> valid_positions;
        valid_positions.resize(size);
        int valid_count = 0;

        for (int i = 0; i < size; ++i) {
            const Vector3 &block_pos = pos_list[i];
            float world_y = data->base_y_position + block_pos.y;
            
            if (world_y >= data->min_height && world_y <= data->max_height) {
                valid_positions.set(valid_count++, block_pos);
            }
        }

        if (valid_count > 0) {
            valid_positions.resize(valid_count);
            filtered_positions[block_type] = valid_positions;
        }
    }

    data->categorized_positions = filtered_positions;
    data->block_biomes = block_biomes;

    // メッシュ生成処理へ渡す
    data->built_data = ChunkMeshBuilder::build_chunk_data_async(
        data->categorized_positions
    );
    data->has_data = true;
    
    UtilityFunctions::print(vformat("[ChunkLoader] Coord (%d, %d) parsed blocks count: %d, biomes count: %d", 
        data->coord.x, data->coord.y, data->categorized_positions.size(), data->block_biomes.size()));

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
    UtilityFunctions::print(vformat("Chunk loader time: %d ms", (int)duration_ms));
}

Node3D *ChunkLoader::create_chunk_node(const Vector2i &coord, float chunk_size, const PureChunkData &built_data) {
    Node3D *chunk_node = memnew(Node3D);
    chunk_node->set_name(vformat("Chunk_%d_%d", coord.x, coord.y));

    Vector3 pos(coord.x * chunk_size, 0.0f, coord.y * chunk_size);
    chunk_node->set_position(pos);

    ChunkMeshBuilder::apply_chunk_data_to_node(chunk_node, built_data);
    return chunk_node;
}