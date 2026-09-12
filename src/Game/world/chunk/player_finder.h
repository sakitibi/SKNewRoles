#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/node_path.hpp>

namespace godot {
    class PlayerFinder {
    public:
        static Node3D *find_local_player(Node *context_node, const NodePath &player_path, uint64_t &io_player_instance_id);
    };
}