#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input.hpp>

namespace godot {
    class SpectatorComponent : public Node {
        GDCLASS(SpectatorComponent, Node)

        private:
            bool is_spectator = false;
            const float SPECTATOR_SPEED = 10.0f;

            CharacterBody3D *target_player = nullptr;
            Camera3D *camera = nullptr;
            Input *input = nullptr;

        protected:
            static void _bind_methods();

        public:
            SpectatorComponent();
            ~SpectatorComponent();

            void setup(CharacterBody3D *p_player, Camera3D *p_camera);
            void process_movement(double delta);

            void set_spectator_mode(bool p_enable);
            bool get_is_spectator() const { return is_spectator; }
    };
}