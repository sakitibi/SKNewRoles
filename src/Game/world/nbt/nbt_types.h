#pragma once

#include <unordered_map>
#include <variant>
#include <vector>
#include <string>
#include <cstdint>
#include <godot_cpp/variant/variant.hpp>

namespace godot {

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

    struct NBTValue;
    using NBTList = std::vector<NBTValue>;
    using NBTCompound = std::unordered_map<std::string, NBTValue>;

    struct NBTValue {
        NBTTagType type;
        std::variant<
            int8_t,
            int16_t,
            int32_t,
            int64_t,
            float,
            double,
            std::string,
            std::vector<uint8_t>,
            std::vector<int32_t>,
            std::vector<int64_t>,
            NBTList,
            NBTCompound
        > data;

        NBTValue();

        Variant to_godot_variant() const;
    };
}