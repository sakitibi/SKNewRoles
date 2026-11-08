#pragma once

#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/classes/node3d.hpp>

namespace godot {
    class ChunkVeritier {
        public:
            static void verity_initial_collisions(const HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map);
    };
}