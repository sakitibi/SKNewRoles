#pragma once

#include "chunk_manager.h"
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/vector2i.hpp>

namespace godot {
    class ChunkUpdater {
    public:
        static void update_chunks_around_player(ChunkManager *manager, const Vector3 &center_pos);
        static void load_chunk(ChunkManager *manager, const Vector2i &coord);
    };
}