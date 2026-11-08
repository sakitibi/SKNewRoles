#include "chunk_mesh_builder.h"

#include "builders/chunk_data_parser.h"
#include "builders/chunk_mesh_builder_new.h"
#include "builders/chunk_node_applier.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <chrono>

using namespace godot;

ChunkMeshBuilder::ChunkMeshBuilder() {}
ChunkMeshBuilder::~ChunkMeshBuilder() {}

void ChunkMeshBuilder::_bind_methods() {}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(
    const Dictionary &chunk_data,
    int min_section_y,
    int max_section_y
) {
    return ChunkDataParser::parse_chunk_positions(chunk_data, min_section_y, max_section_y);
}

std::unordered_map<Vector3i, std::string, NativeVector3iHash> ChunkMeshBuilder::parse_chunk_biomes(
    const NBTCompound &chunk_nbt,
    int min_section_y,
    int max_section_y
) {
    std::unordered_map<Vector3i, std::string, NativeVector3iHash> block_biomes;
    if (chunk_nbt.empty()) return block_biomes;

    auto it = chunk_nbt.find("sections");
    if (it == chunk_nbt.end()) {
        it = chunk_nbt.find("Sections");
    }
    if (it == chunk_nbt.end() || it->second.type != TAG_LIST) return block_biomes;

    const NBTList &sections = std::get<NBTList>(it->second.data);

    for (const auto &sec_val : sections) {
        if (sec_val.type != TAG_COMPOUND) continue;
        const NBTCompound &section = std::get<NBTCompound>(sec_val.data);

        // セクションのY座標を取得
        auto y_it = section.find("Y");
        if (y_it == section.end()) {
            y_it = section.find("y");
        }
        if (y_it == section.end()) continue;

        int section_y = 0;
        if (y_it->second.type == TAG_BYTE) section_y = std::get<int8_t>(y_it->second.data);
        else if (y_it->second.type == TAG_SHORT) section_y = std::get<int16_t>(y_it->second.data);
        else if (y_it->second.type == TAG_INT) section_y = std::get<int32_t>(y_it->second.data);

        if (section_y > 127) section_y -= 256;
        if (section_y < min_section_y || section_y > max_section_y) continue;

        auto bio_it = section.find("biomes");
        if (bio_it == section.end()) {
            bio_it = section.find("Biomes");
        }
        if (bio_it == section.end() || bio_it->second.type != TAG_COMPOUND) continue;

        const NBTCompound &biomes_dict = std::get<NBTCompound>(bio_it->second.data);

        auto pal_it = biomes_dict.find("palette");
        if (pal_it == biomes_dict.end()) {
            pal_it = biomes_dict.find("Palette");
        }
        if (pal_it == biomes_dict.end() || pal_it->second.type != TAG_LIST) continue;

        const NBTList &biome_palette = std::get<NBTList>(pal_it->second.data);

        const std::vector<int64_t> *biome_data_array = nullptr;
        auto data_it = biomes_dict.find("data");
        if (data_it == biomes_dict.end()) {
            data_it = biomes_dict.find("Data");
        }
        if (data_it != biomes_dict.end() && data_it->second.type == TAG_LONG_ARRAY) {
            biome_data_array = &std::get<std::vector<int64_t>>(data_it->second.data);
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int bx = x / 4;
                    int by = y / 4;
                    int bz = z / 4;
                    int b_idx = by * 16 + bz * 4 + bx;

                    int palette_idx = 0;
                    if (biome_data_array && b_idx >= 0 && b_idx < static_cast<int>(biome_data_array->size())) {
                        palette_idx = static_cast<int>((*biome_data_array)[b_idx]);
                    }

                    if (palette_idx >= 0 && palette_idx < static_cast<int>(biome_palette.size())) {
                        const auto &b_entry_val = biome_palette[palette_idx];
                        std::string biome_name = "minecraft:plains";

                        if (b_entry_val.type == TAG_COMPOUND) {
                            const NBTCompound &b_entry = std::get<NBTCompound>(b_entry_val.data);
                            auto name_it = b_entry.find("Name");
                            if (name_it == b_entry.end()) name_it = b_entry.find("name");
                            if (name_it != b_entry.end() && name_it->second.type == TAG_STRING) {
                                biome_name = std::get<std::string>(name_it->second.data);
                            }
                        }

                        int world_y = section_y * 16 + y;
                        Vector3i block_pos(x, world_y, z);
                        block_biomes[block_pos] = biome_name;
                    }
                }
            }
        }
    }

    return block_biomes;
}

PureChunkData ChunkMeshBuilder::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions
) {
    auto start_time = std::chrono::high_resolution_clock::now();

    PureChunkData result = ChunkMeshBuilderNew::build_chunk_data_async(categorized_positions);

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();

    UtilityFunctions::print(vformat("Chunk build time: %d ms", (int)duration_ms));

    return result;
}

void ChunkMeshBuilder::apply_chunk_data_to_node(Node3D *parent_node, const PureChunkData &built_data) {
    ChunkNodeApplier::apply_chunk_data_to_node(parent_node, built_data);
}