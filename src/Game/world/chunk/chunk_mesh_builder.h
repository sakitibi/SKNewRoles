#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <vector>
#include <string>
#include <unordered_map>

namespace godot {
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

            static PureChunkData build_chunk_data_async(
                const HashMap<String, Vector<Vector3>> &categorized_positions,
                bool p_is_initial_load = false
            );

            static void apply_chunk_data_to_node(Node3D *parent_node, const PureChunkData &built_data);
    };
}