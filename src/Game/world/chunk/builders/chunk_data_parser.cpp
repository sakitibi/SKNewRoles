#include "chunk_data_parser.h"
#include "../../../Blocks/block_registry.h"
#include <godot_cpp/variant/array.hpp>

using namespace godot;

int ChunkDataParser::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (palette_size <= 1) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = y * 256 + z * 16 + x;
    int entries_per_long = 64 / bits_per_entry;
    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index < 0 || long_index >= data.size()) return 0;

    uint64_t raw_long = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1;
    return static_cast<int>((raw_long >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkDataParser::parse_chunk_positions(
    const Dictionary &chunk_data,
    int min_section_y,
    int max_section_y
) {
    HashMap<String, Vector<Vector3>> categorized_positions;
    if (!chunk_data.has("sections")) return categorized_positions;

    Array sections = chunk_data["sections"];

    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int section_y = section["Y"];
        if (section_y < min_section_y || section_y > max_section_y) continue;

        Dictionary block_states = section["block_states"];
        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        PackedInt64Array data_array;
        if (block_states.has("data")) {
            data_array = block_states["data"];
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = 0;
                    if (!data_array.is_empty()) {
                        p_idx = get_palette_index(data_array, palette.size(), x, y, z);
                    }

                    if (p_idx >= 0 && p_idx < palette.size()) {
                        Dictionary b_entry = palette[p_idx];
                        String block_name = b_entry.get("Name", "minecraft:air");

                        if (block_name != "minecraft:air" && BlockRegistry::has_block(block_name)) {
                            Vector3 pos(static_cast<float>(x), static_cast<float>(section_y * 16 + y), static_cast<float>(z));
                            categorized_positions[block_name].append(pos);
                        }
                    }
                }
            }
        }
    }

    return categorized_positions;
}