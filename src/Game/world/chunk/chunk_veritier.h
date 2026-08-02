#pragma once

#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/classes/node3d.hpp>

namespace godot {
    class ChunkVeritier {
        public:
            static void verity_initial_collisions(const HashMap<Vector2i, Node3D *> &loaded_chunks);
    };
}