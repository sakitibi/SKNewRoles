#include "mca_parser.h"
#include <cmath>
#include <cstring>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

MCAParser::MCAParser() {}
MCAParser::~MCAParser() {}

uint8_t MCAParser::read_u8() {
    return (nbt_cursor < nbt_size) ? nbt_ptr[nbt_cursor++] : 0;
}

int16_t MCAParser::read_i16() {
    if (nbt_cursor + 2 > nbt_size) return 0;
    uint16_t v = (uint16_t(nbt_ptr[nbt_cursor]) << 8) | uint16_t(nbt_ptr[nbt_cursor + 1]);
    nbt_cursor += 2;
    return static_cast<int16_t>(v);
}

int32_t MCAParser::read_i32() {
    if (nbt_cursor + 4 > nbt_size) return 0;
    uint32_t v = (uint32_t(nbt_ptr[nbt_cursor]) << 24) | (uint32_t(nbt_ptr[nbt_cursor + 1]) << 16) |
                 (uint32_t(nbt_ptr[nbt_cursor + 2]) << 8) | uint32_t(nbt_ptr[nbt_cursor + 3]);
    nbt_cursor += 4;
    return static_cast<int32_t>(v);
}

int64_t MCAParser::read_i64() {
    if (nbt_cursor + 8 > nbt_size) return 0;
    uint64_t v = 0;
    for (int i = 0; i < 8; i++) v = (v << 8) | uint64_t(nbt_ptr[nbt_cursor + i]);
    nbt_cursor += 8;
    return static_cast<int64_t>(v);
}

String MCAParser::read_string() {
    int16_t len = read_i16();
    if (len <= 0 || nbt_cursor + len > nbt_size) return String();
    String str = String::utf8((const char*)(nbt_ptr + nbt_cursor), len);
    nbt_cursor += len;
    return str;
}

Variant MCAParser::parse_tag_payload(uint8_t type) {
    switch (type) {
        case TAG_BYTE: return read_u8();
        case TAG_SHORT: return read_i16();
        case TAG_INT: return read_i32();
        case TAG_LONG: return read_i64();
        case TAG_FLOAT: { int32_t i = read_i32(); float f; std::memcpy(&f, &i, 4); return f; }
        case TAG_DOUBLE: { int64_t i = read_i64(); double d; std::memcpy(&d, &i, 8); return d; }
        case TAG_BYTE_ARRAY: {
            int32_t len = read_i32();
            PackedByteArray arr; arr.resize(len);
            if (len > 0 && nbt_cursor + len <= nbt_size) {
                std::memcpy(arr.ptrw(), nbt_ptr + nbt_cursor, len);
                nbt_cursor += len;
            }
            return arr;
        }
        case TAG_STRING: return read_string();
        case TAG_LIST: {
            uint8_t elem_type = read_u8();
            int32_t len = read_i32();
            Array list;
            for (int32_t i = 0; i < len; i++) list.append(parse_tag_payload(elem_type));
            return list;
        }
        case TAG_COMPOUND: {
            Dictionary dict;
            while (nbt_cursor < nbt_size) {
                uint8_t tag_type = read_u8();
                if (tag_type == TAG_END) break;
                String key = read_string();
                dict[key] = parse_tag_payload(tag_type);
            }
            return dict;
        }
        case TAG_INT_ARRAY: {
            int32_t len = read_i32();
            PackedInt32Array arr; arr.resize(len);
            for (int32_t i = 0; i < len; i++) arr[i] = read_i32();
            return arr;
        }
        case TAG_LONG_ARRAY: {
            int32_t len = read_i32();
            PackedInt64Array arr; arr.resize(len);
            for (int32_t i = 0; i < len; i++) arr[i] = read_i64();
            return arr;
        }
        default: return Variant();
    }
}

Dictionary MCAParser::parse_nbt_bytes(const PackedByteArray &bytes) {
    if (bytes.is_empty()) return Dictionary();
    nbt_ptr = bytes.ptr();
    nbt_size = bytes.size();
    nbt_cursor = 0;

    if (read_u8() != TAG_COMPOUND) return Dictionary();
    String root_name = read_string();
    Dictionary root_dict;
    root_dict[root_name] = parse_tag_payload(TAG_COMPOUND);
    return root_dict;
}

PackedByteArray MCAParser::get_raw_chunk_nbt(const String &path, int rel_x, int rel_z) {
    Ref<FileAccess> file = FileAccess::open(path, FileAccess::READ);
    if (file.is_null()) return PackedByteArray();

    int index = (rel_x % 32) + (rel_z % 32) * 32;
    file->seek(index * 4);

    uint32_t location_raw = file->get_32();
    #if defined(__LITTLE_ENDIAN__) || defined(__x86_64__) || defined(_M_AMD64) || defined(_M_IX86)
    location_raw = __builtin_bswap32(location_raw);
    #endif

    uint32_t sector_offset = location_raw >> 8;
    if (sector_offset == 0) return PackedByteArray();

    file->seek(sector_offset * 4096);
    uint32_t length = file->get_32();
    #if defined(__LITTLE_ENDIAN__) || defined(__x86_64__) || defined(_M_AMD64) || defined(_M_IX86)
    length = __builtin_bswap32(length);
    #endif

    uint8_t compression_type = file->get_8();
    if (length <= 1) return PackedByteArray();

    PackedByteArray compressed_data = file->get_buffer(length - 1);
    
    if (compression_type == 2) {
        return compressed_data.decompress_dynamic(16 * 1024 * 1024, FileAccess::COMPRESSION_DEFLATE);
    }
    return PackedByteArray();
}

Dictionary MCAParser::parse_chunk(const String &region_folder_path, int chunk_x, int chunk_z) {
    int rx = static_cast<int>(std::floor(chunk_x / 32.0f));
    int rz = static_cast<int>(std::floor(chunk_z / 32.0f));

    int rel_x = (chunk_x % 32 + 32) % 32;
    int rel_z = (chunk_z % 32 + 32) % 32;

    String mca_path = vformat("%sr.%d.%d.mca", region_folder_path, rx, rz);

    PackedByteArray raw_nbt = get_raw_chunk_nbt(mca_path, rel_x, rel_z);
    if (raw_nbt.is_empty()) {
        return Dictionary();
    }

    return parse_nbt_bytes(raw_nbt);
}