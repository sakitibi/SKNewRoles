#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <vector>
#include <string>
#include <unordered_map>
#include "../nbt/nbt_types.h"

namespace godot {
    struct NativeVector3iHash {
        std::size_t operator()(const Vector3i &v) const {
            std::size_t h1 = std::hash<int>()(v.x);
            std::size_t h2 = std::hash<int>()(v.y);
            std::size_t h3 = std::hash<int>()(v.z);
            return h1 ^ (h2 << 1) ^ (h3 << 2);
        }
    };

    struct PureSurfaceData {
        Ref<Material> material;
        std::vector<Vector3> vertices;
        std::vector<Vector3> normals;
        std::vector<Vector2> uvs;
        std::vector<int32_t> indices;
        int vertex_count = 0;
    };

    struct PureChunkData {
        std::unordered_map<std::string, std::vector<PureSurfaceData>> block_surfaces;
        PackedVector3Array collision_faces;
    };

    class ChunkMeshBuilder : public Object {
        GDCLASS(ChunkMeshBuilder, Object)
        
        protected:
            static void _bind_methods();

        public:
            ChunkMeshBuilder();
            ~ChunkMeshBuilder();

            static HashMap<String, Vector<Vector3>> parse_chunk_positions(
                const Dictionary &chunk_data,
                int min_section_y = -4,
                int max_section_y = 19
            );

            static std::unordered_map<Vector3i, std::string, NativeVector3iHash> parse_chunk_biomes(
                const NBTCompound &chunk_nbt,
                int min_section_y = -4,
                int max_section_y = 19
            );

            static PureChunkData build_chunk_data_async(
                const HashMap<String, Vector<Vector3>> &categorized_positions
            );

            static void apply_chunk_data_to_node(Node3D *parent_node, const PureChunkData &built_data);
    };
}