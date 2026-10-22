#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <vector>
#include <string>
#include <unordered_map>
#include "../chunk_mesh_builder.h"

namespace godot {
    class ChunkMeshBuilderNew : public Object {
        GDCLASS(ChunkMeshBuilderNew, Object)

        protected:
            static void _bind_methods() {}

        public:
            ChunkMeshBuilderNew() {}
            ~ChunkMeshBuilderNew() {}

            static PureChunkData build_chunk_data_async(
                const HashMap<String, Vector<Vector3>> &categorized_positions,
                bool p_is_initial_load = false
            );
    };
}