#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class ChunkBlockEditor : public Object {
        GDCLASS(ChunkBlockEditor, Object)

        protected:
            static void _bind_methods();

        public:
            ChunkBlockEditor();
            ~ChunkBlockEditor();

            static void add_block_at_world_pos(
                HashMap<Vector2i, Node3D*> &loaded_chunks,
                HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map,
                float chunk_size,
                const Vector3 &world_pos,
                const String &block_type
            );

            static void rebuild_chunk_mesh(
                HashMap<Vector2i, Node3D*> &loaded_chunks,
                HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map,
                float chunk_size,
                const Vector2i &chunk_coord
            );
    };
}