#pragma once

#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class ChunkCollisionBuilder {
        public:
            static PackedVector3Array build_collision_faces(
                const HashMap<String, Vector<Vector3>> &categorized_positions
            );
    };
}