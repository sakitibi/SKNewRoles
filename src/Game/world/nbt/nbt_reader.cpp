#include "nbt_reader.h"
#include <cstring>

using namespace godot;

NBTReader::NBTReader(const uint8_t *data, size_t data_size)
    : ptr(data), size(data_size), cursor(0) {}

uint8_t NBTReader::read_u8() {
    return (cursor < size) ? ptr[cursor++] : 0;
}

int16_t NBTReader::read_i16() {
    if (cursor + 2 > size) return 0;
    uint16_t v = (uint16_t(ptr[cursor]) << 8) | uint16_t(ptr[cursor + 1]);
    cursor += 2;
    return static_cast<int16_t>(v);
}

int32_t NBTReader::read_i32() {
    if (cursor + 4 > size) return 0;
    uint32_t v = (uint32_t(ptr[cursor]) << 24) | (uint32_t(ptr[cursor + 1]) << 16) |
                 (uint32_t(ptr[cursor + 2]) << 8) | uint32_t(ptr[cursor + 3]);
    cursor += 4;
    return static_cast<int32_t>(v);
}

int64_t NBTReader::read_i64() {
    if (cursor + 8 > size) return 0;
    uint64_t v = 0;
    for (int i = 0; i < 8; i++) v = (v << 8) | uint64_t(ptr[cursor + i]);
    cursor += 8;
    return static_cast<int64_t>(v);
}

std::string NBTReader::read_string() {
    int16_t len = read_i16();
    if (len <= 0 || cursor + len > size) return "";
    std::string str(reinterpret_cast<const char*>(ptr + cursor), len);
    cursor += len;
    return str;
}

NBTValue NBTReader::parse_tag_payload(uint8_t type) {
    NBTValue val;
    val.type = static_cast<NBTTagType>(type);

    switch (type) {
        case TAG_BYTE: {
            int8_t b = static_cast<int8_t>(read_u8());
            val.data = b;
            break;
        }
        case TAG_SHORT: {
            int16_t s = read_i16();
            val.data = s;
            break;
        }
        case TAG_INT: {
            int32_t i = read_i32();
            val.data = i;
            break;
        }
        case TAG_LONG: {
            int64_t l = read_i64();
            val.data = l;
            break;
        }
        case TAG_FLOAT: {
            int32_t i = read_i32();
            float f; std::memcpy(&f, &i, 4);
            val.data = f;
            break;
        }
        case TAG_DOUBLE: {
            int64_t i = read_i64();
            double d; std::memcpy(&d, &i, 8);
            val.data = d;
            break;
        }
        case TAG_BYTE_ARRAY: {
            int32_t len = read_i32();
            std::vector<uint8_t> arr;
            if (len > 0 && cursor + len <= size) {
                arr.resize(len);
                std::memcpy(arr.data(), ptr + cursor, len);
                cursor += len;
            }
            val.data = arr;
            break;
        }
        case TAG_STRING: val.data = read_string(); break;
        case TAG_LIST: {
            uint8_t elem_type = read_u8();
            int32_t len = read_i32();
            NBTList list;
            list.reserve(len);
            for (int32_t i = 0; i < len; i++) {
                list.push_back(parse_tag_payload(elem_type));
            }
            val.data = list;
            break;
        }
        case TAG_COMPOUND: {
            NBTCompound dict;
            while (cursor < size) {
                uint8_t tag_type = read_u8();
                if (tag_type == TAG_END) break;
                std::string key = read_string();
                dict[key] = parse_tag_payload(tag_type);
            }
            val.data = dict;
            break;
        }
        case TAG_INT_ARRAY: {
            int32_t len = read_i32();
            std::vector<int32_t> arr(len);
            for (int32_t i = 0; i < len; i++) arr[i] = read_i32();
            val.data = arr;
            break;
        }
        case TAG_LONG_ARRAY: {
            int32_t len = read_i32();
            std::vector<int64_t> arr(len);
            for (int32_t i = 0; i < len; i++) arr[i] = read_i64();
            val.data = arr;
            break;
        }
        default: break;
    }
    return val;
}

NBTCompound NBTReader::parse_root() {
    if (size == 0) return {};

    uint8_t root_type = read_u8();
    if (root_type != TAG_COMPOUND) return {};

    std::string root_name = read_string();
    NBTValue result = parse_tag_payload(TAG_COMPOUND);

    if (std::holds_alternative<NBTCompound>(result.data)) {
        return std::get<NBTCompound>(result.data);
    }
    return {};
}