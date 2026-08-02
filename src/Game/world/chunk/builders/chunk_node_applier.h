#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include "chunk_mesh_builder_new.h"

namespace godot {
    class ChunkNodeApplier {
        public:
            static void apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkDataNew &built_data);
    };
}