#pragma once

#include <godot_cpp/classes/node3d.hpp>

namespace godot {
    class ChunkSpawner {
        public:
            static void spawn_falling_block(Node3D *parent_node, const Vector3 &spawn_pos, const String &block_type);
    };
}