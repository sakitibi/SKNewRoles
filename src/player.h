#pragma once

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input_event.hpp>
#include <godot_cpp/classes/input.hpp>

namespace godot {
    class SNR2Player : public CharacterBody3D {
        GDCLASS(SNR2Player, CharacterBody3D)

        private:
            int max_hp = 20;
            int current_hp = 20;

            bool was_in_air = false;                // 前フレームで空中だったか
            float fall_start_y = 0.0f;              // 落下を開始した(または最高到達点の)Y座標
            const float SAFE_FALL_HEIGHT = 3.0f;    // 3メートル(ブロック)までは無傷
            const int DAMAGE_PER_BLOCK = 1;          // 1ブロック超過ごとに 1 ダメージ

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

            void set_max_hp(int p_hp);
            int get_max_hp() const;

            void set_current_hp(int p_hp);
            int get_current_hp() const;

            void take_damage(int amount);
            void heal(int amount);
    };
}