#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>

namespace godot {
    class PlayerAttack {
        public:
            static void process_attack(Node3D *player_node, Camera3D *camera);
    };
}