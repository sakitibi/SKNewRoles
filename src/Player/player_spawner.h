#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/node.hpp>

namespace godot {
    class PlayerSpawner : public RefCounted {
        GDCLASS(PlayerSpawner, RefCounted);

    protected:
        static void _bind_methods();

    public:
        Node3D *spawn_player(Node *parent);

        void set_player_physics_enabled(Node3D *player_instance, bool enabled);
    };
}