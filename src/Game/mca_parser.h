#pragma once

#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/variant.hpp>

namespace godot {
    // NBTタグの識別子
    enum NBTTagType {
        TAG_END = 0,
        TAG_BYTE = 1,
        TAG_SHORT = 2,
        TAG_INT = 3,
        TAG_LONG = 4,
        TAG_FLOAT = 5,
        TAG_DOUBLE = 6,
        TAG_BYTE_ARRAY = 7,
        TAG_STRING = 8,
        TAG_LIST = 9,
        TAG_COMPOUND = 10,
        TAG_INT_ARRAY = 11,
        TAG_LONG_ARRAY = 12
    };

    class MCAParser {
        private:
            const uint8_t *nbt_ptr = nullptr;
            size_t nbt_size = 0;
            size_t nbt_cursor = 0;

            // バイナリ読取ヘルパー
            uint8_t read_u8();
            int16_t read_i16();
            int32_t read_i32();
            int64_t read_i64();
            String read_string();

            // NBT 再帰パース処理
            Variant parse_tag_payload(uint8_t type);
            Dictionary parse_nbt_bytes(const PackedByteArray &bytes);

            // MCA 解凍
            PackedByteArray get_raw_chunk_nbt(const String &mca_file_path, int rel_x, int rel_z);

        public:
            MCAParser();
            ~MCAParser();

            Dictionary parse_chunk(const String &region_folder_path, int chunk_x, int chunk_z);
    };
}