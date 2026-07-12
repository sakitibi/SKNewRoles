#pragma once

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input_event.hpp>

namespace godot {

class SNR2Player : public CharacterBody3D {
    GDCLASS(SNR2Player, CharacterBody3D)

    private:
        float gravity = 9.8f;
        const float SPEED = 5.0f;
        const float JUMP_VELOCITY = 4.5f;

        // 視点操作用パラメータ
        float mouse_sensitivity = 0.003f;
        
        // カメラの上下回転角度（ラジアン）
        float camera_rotation_x = 0.0f;

        const float LIMIT_ANGLE_X = 1.48f;

        Camera3D *camera = nullptr;

    protected:
        static void _bind_methods();

    public:
        SNR2Player();
        ~SNR2Player();

        void _ready() override;
        void _physics_process(double delta) override;
        void _input(const Ref<InputEvent> &event) override;
    };
}