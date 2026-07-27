#pragma once

#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class ChunkCollisionBuilder {
        public:
            // カテゴリ分けされたブロック位置からコリゴン用ポリゴン配列を構築
            static PackedVector3Array build_collision_faces(
                const HashMap<String, Vector<Vector3>> &categorized_positions
            );
    };
}