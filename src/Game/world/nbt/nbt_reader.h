#pragma once

#include "nbt_types.h"

namespace godot {
    class NBTReader {
        private:
            const uint8_t *ptr = nullptr;
            size_t size = 0;
            size_t cursor = 0;

            uint8_t read_u8();
            int16_t read_i16();
            int32_t read_i32();
            int64_t read_i64();
            std::string read_string();

            NBTValue parse_tag_payload(uint8_t type);

        public:
            NBTReader(const uint8_t *data, size_t data_size);
            ~NBTReader() = default;

            NBTCompound parse_root();
    };
}