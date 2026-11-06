#include "nbt_types.h"

#include <cstring>
#include <cstdint>
#include <string>
#include <vector>

#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>

using namespace godot;

NBTValue::NBTValue() : type(TAG_END), data(int8_t(0)) {}

Variant NBTValue::to_godot_variant() const {
    switch (type) {
        case TAG_BYTE: return std::get<int8_t>(data);
        case TAG_SHORT: return std::get<int16_t>(data);
        case TAG_INT: return std::get<int32_t>(data);
        case TAG_LONG: return std::get<int64_t>(data);
        case TAG_FLOAT: return std::get<float>(data);
        case TAG_DOUBLE: return std::get<double>(data);
        case TAG_STRING: return String::utf8(std::get<std::string>(data).c_str());
        case TAG_BYTE_ARRAY: {
            const auto &vec = std::get<std::vector<uint8_t>>(data);
            PackedByteArray arr;
            arr.resize(vec.size());
            if (!vec.empty()) {
                std::memcpy(arr.ptrw(), vec.data(), vec.size());
            }
            return arr;
        }
        case TAG_INT_ARRAY: {
            const auto &vec = std::get<std::vector<int32_t>>(data);
            PackedInt32Array arr;
            arr.resize(vec.size());
            for (size_t i = 0; i < vec.size(); ++i) arr[i] = vec[i];
            return arr;
        }
        case TAG_LONG_ARRAY: {
            const auto &vec = std::get<std::vector<int64_t>>(data);
            PackedInt64Array arr;
            arr.resize(vec.size());
            for (size_t i = 0; i < vec.size(); ++i) arr[i] = vec[i];
            return arr;
        }
        case TAG_LIST: {
            const auto &list = std::get<NBTList>(data);
            Array arr;
            arr.resize(list.size());
            for (size_t i = 0; i < list.size(); ++i) {
                arr[i] = list[i].to_godot_variant();
            }
            return arr;
        }
        case TAG_COMPOUND: {
            const auto &comp = std::get<NBTCompound>(data);
            Dictionary dict;
            for (const auto &pair : comp) {
                dict[String::utf8(pair.first.c_str())] = pair.second.to_godot_variant();
            }
            return dict;
        }
        default: return Variant();
    }
}