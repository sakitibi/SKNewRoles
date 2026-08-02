#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>

namespace godot {
    class SpectatorComponent : public Node {
        GDCLASS(SpectatorComponent, Node)

        private:
            const float SPECTATOR_SPEED = 15.0f;

            CharacterBody3D *target_player = nullptr;
            Camera3D *camera = nullptr;
            Input *input = nullptr;

            void set_node_visible_recursive(Node *p_node, bool p_visible);

        protected:
            static void _bind_methods();

        public:
            SpectatorComponent();
            ~SpectatorComponent();

            bool is_spectator = false;

            void setup(CharacterBody3D *p_player, Camera3D *p_camera);
            void process_movement(double delta);

            void set_spectator_mode(bool p_enable);
            bool get_is_spectator() const { return is_spectator; }
    };
}