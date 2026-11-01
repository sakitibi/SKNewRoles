#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>

namespace godot {
    class PlayerAttack : public RefCounted {
        GDCLASS(PlayerAttack, RefCounted);

    protected:
        static void _bind_methods();

    public:
        Dictionary process_attack(Node3D *player_node, Camera3D *camera);
    };
}