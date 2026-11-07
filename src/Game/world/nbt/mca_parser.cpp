#include "mca_parser.h"
#include "nbt_reader.h"
#include <cmath>
#include <chrono>
#include <fstream>
#include <zlib.h>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

uint32_t MCAParser::bswap32_native(uint32_t val) {
    return ((val >> 24) & 0xff) |
           ((val << 8) & 0xff0000) |
           ((val >> 8) & 0xff00) |
           ((val << 24) & 0xff000000);
}

MCAParser::MCAParser() {}
MCAParser::~MCAParser() {}

std::vector<uint8_t> MCAParser::get_raw_chunk_nbt_native(const std::string &mca_file_path, int rel_x, int rel_z) {
    UtilityFunctions::print(vformat("[MCAParser] Opening MCA file: %s", String::utf8(mca_file_path.c_str())));

    std::ifstream file(mca_file_path, std::ios::binary);
    if (!file.is_open()) {
        UtilityFunctions::print(vformat("[MCAParser] ERROR: Failed to open MCA file at: %s", String::utf8(mca_file_path.c_str())));
        return {};
    }

    int index = (rel_x % 32) + (rel_z % 32) * 32;
    file.seekg(index * 4);

    uint32_t location_raw = 0;
    file.read(reinterpret_cast<char*>(&location_raw), 4);
    location_raw = bswap32_native(location_raw);

    uint32_t sector_offset = location_raw >> 8;

    if (sector_offset == 0) {
        UtilityFunctions::print(vformat("[MCAParser] Chunk (%d, %d) is not generated yet (sector_offset == 0)", rel_x, rel_z));
        return {};
    }

    file.seekg(sector_offset * 4096);
    uint32_t length = 0;
    file.read(reinterpret_cast<char*>(&length), 4);
    length = bswap32_native(length);

    uint8_t compression_type = 0;
    file.read(reinterpret_cast<char*>(&compression_type), 1);

    UtilityFunctions::print(vformat("[MCAParser] Chunk found at rel(%d, %d) -> length: %d, compression: %d", rel_x, rel_z, length, compression_type));

    if (length <= 1) {
        UtilityFunctions::print(vformat("[MCAParser] WARNING: Invalid chunk length (%d) at rel(%d, %d)", length, rel_x, rel_z));
        return {};
    }

    std::vector<uint8_t> compressed_data(length - 1);
    file.read(reinterpret_cast<char*>(compressed_data.data()), length - 1);

    if (compression_type == 2) {
        uLongf dest_len = 16 * 1024 * 1024;
        std::vector<uint8_t> decompressed(dest_len);

        int res = uncompress(
            decompressed.data(), &dest_len,
            compressed_data.data(), compressed_data.size()
        );

        if (res == Z_OK) {
            decompressed.resize(dest_len);
            UtilityFunctions::print(vformat("[MCAParser] zlib uncompress SUCCESS: %d bytes -> %d bytes", (int)compressed_data.size(), (int)dest_len));
            return decompressed;
        } else {
            UtilityFunctions::print(vformat("[MCAParser] ERROR: zlib uncompress FAILED with error code: %d (Z_MEM_ERROR=-2, Z_BUF_ERROR=-5, Z_DATA_ERROR=-3)", res));
        }
    } else {
        UtilityFunctions::print(vformat("[MCAParser] WARNING: Unsupported compression type: %d (Expected 2 for zlib)", compression_type));
    }

    return {};
}

Dictionary MCAParser::parse_chunk(const String &region_folder_path, int chunk_x, int chunk_z) {
    auto start_time = std::chrono::high_resolution_clock::now();

    int rx = static_cast<int>(std::floor(chunk_x / 32.0f));
    int rz = static_cast<int>(std::floor(chunk_z / 32.0f));
    std::string mca_path = std::string(region_folder_path.utf8().get_data()) + "r." + std::to_string(rx) + "." + std::to_string(rz) + ".mca";

    int rel_x = ((chunk_x % 32) + 32) % 32;
    int rel_z = ((chunk_z % 32) + 32) % 32;

    std::vector<uint8_t> raw_nbt = get_raw_chunk_nbt_native(mca_path, rel_x, rel_z);
    if (raw_nbt.empty()) {
        UtilityFunctions::print(vformat("[MCAParser] parse_chunk: raw_nbt is empty for chunk (%d, %d)", chunk_x, chunk_z));
        return Dictionary();
    }

    NBTReader reader(raw_nbt.data(), raw_nbt.size());
    NBTCompound root_compound = reader.parse_root();
    
    NBTValue root_val;
    root_val.type = TAG_COMPOUND;
    root_val.data = root_compound;
    
    Variant res_var = root_val.to_godot_variant();
    
    Dictionary result;
    if (res_var.get_type() == Variant::DICTIONARY) {
        result = res_var;
    } else {
        result = Dictionary();
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
    UtilityFunctions::print(vformat("MCA parse time (C++ Native): %d ms", (int)duration_ms));

    return result;
}