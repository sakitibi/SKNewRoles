#pragma once

#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/templates/vector.hpp>

namespace godot {
    class ChunkDataParser {
        private:
            static int get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z);

        public:
            static HashMap<String, Vector<Vector3>> parse_chunk_positions(
                const Dictionary &chunk_data,
                int min_section_y = -4,
                int max_section_y = 19
            );
    };
}