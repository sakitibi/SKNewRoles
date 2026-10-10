#pragma once

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input_event.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/shader_material.hpp>

#include "Game/health_component.h"
#include "Game/spectator_component.h"
#include "Game/fall_damage_component.h"
#include "Game/hunger_component.h"

namespace godot {
    class SNR2Player : public CharacterBody3D {
        GDCLASS(SNR2Player, CharacterBody3D)

        private:
            HealthComponent *health_component = nullptr;
            SpectatorComponent *spectator_component = nullptr;
            FallDamageComponent *fall_damage_component = nullptr;
            HungerComponent *hunger_component = nullptr;

            float gravity = 9.8f;
            const float SPEED = 5.0f;
            const float JUMP_VELOCITY = 4.5f;

            float mouse_sensitivity = 0.003f;
            float camera_rotation_x = 0.0f;
            const float LIMIT_ANGLE_X = 1.48f;

            Camera3D *camera = nullptr;
            Input *input = nullptr;

        protected:
            static void _bind_methods();

        public:
            SNR2Player();
            ~SNR2Player();

            void _ready() override;
            void _physics_process(double delta) override;
            void _input(const Ref<InputEvent> &event) override;

            void apply_custom_skins();

            void set_max_hp(int p_hp);
            int get_max_hp() const;
            void set_current_hp(int p_hp);
            int get_current_hp() const;
            void take_damage(int amount);
            void heal(int amount);

            void set_max_hunger(int p_hunger);
            int get_max_hunger() const;
            void set_current_hunger(int p_hunger);
            int get_current_hunger() const;
            void consume_hunger(int amount);
            void restore_hunger(int amount);

            void die();
            void set_spectator_mode(bool p_enable);
            bool is_spectator() const;

            void _on_hp_changed(int current_hp, int max_hp);
            void _on_hunger_changed(int current_hunger, int max_hunger);
            void _on_player_died();
    };
}