#pragma once

#include "nbt_types.h"
#include <string>
#include <vector>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class MCAParser {
        private:
            static uint32_t bswap32_native(uint32_t val);
            static std::vector<uint8_t> get_raw_chunk_nbt_native(const std::string &mca_file_path, int rel_x, int rel_z);

        public:
            MCAParser();
            ~MCAParser();

            static Dictionary parse_chunk(const String &region_folder_path, int chunk_x, int chunk_z);
    };
}