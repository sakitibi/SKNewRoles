#include "player.h"
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void SNR2Player::_bind_methods() {
}

SNR2Player::SNR2Player() {
    gravity = 9.8f;
}

SNR2Player::~SNR2Player() {
}

void SNR2Player::_ready() {
    input = Input::get_singleton();

    ProjectSettings *settings = ProjectSettings::get_singleton();
    if (settings) {
        gravity = settings->get_setting("physics/3d/default_gravity");
    }

    Node *node = get_node_or_null(NodePath("Camera3D"));
    if (node != nullptr) {
        camera = Object::cast_to<Camera3D>(node);
    }
}

void SNR2Player::_input(const Ref<InputEvent> &event) {
    if (!input) return;

    // 右クリック中のカメラ・視点操作
    if (input->is_mouse_button_pressed(MouseButton::MOUSE_BUTTON_RIGHT)) {
        Ref<InputEventMouseMotion> mouse_motion = event;
        if (mouse_motion.is_valid()) {
            Vector2 delta = mouse_motion->get_relative();

            // プレイヤー本体のY軸回転
            rotate_y(-delta.x * mouse_sensitivity);

            // カメラのX軸（上下）回転制御
            camera_rotation_x -= delta.y * mouse_sensitivity;
            camera_rotation_x = Math::clamp(camera_rotation_x, -LIMIT_ANGLE_X, LIMIT_ANGLE_X);

            if (camera != nullptr) {
                Vector3 cam_rot = camera->get_rotation();
                cam_rot.x = camera_rotation_x;
                camera->set_rotation(cam_rot);
            }
        }
    }
}

void SNR2Player::_physics_process(double delta) {
    if (!input) return;

    Vector3 velocity = get_velocity();

    // 重力計算
    if (!is_on_floor()) {
        velocity.y -= gravity * (float)delta;
    }

    // ジャンプ処理
    bool is_jump_pressed = input->is_key_pressed(KEY_SPACE) || input->is_action_pressed("ui_accept");
    if (is_jump_pressed && is_on_floor()) {
        velocity.y = JUMP_VELOCITY;
    }

    // 移動入力の取得
    Vector2 input_dir = Vector2(0, 0);
    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) input_dir.x += 1.0f;
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) input_dir.x -= 1.0f;
    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) input_dir.y += 1.0f;
    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) input_dir.y -= 1.0f;

    if (input_dir.length_squared() > 0.0f) {
        input_dir = input_dir.normalized();

        // プレイヤーの現在のY軸回転に基づいた方向ベクトルを取得
        Basis basis = get_global_transform().basis;
        Vector3 forward = -basis.get_column(2); // 前方向 (-Z)
        Vector3 right = basis.get_column(0);    // 右方向 (+X)

        forward.y = 0.0f;
        right.y = 0.0f;
        forward.normalize();
        right.normalize();

        Vector3 direction = (forward * -input_dir.y + right * input_dir.x).normalized();

        velocity.x = direction.x * SPEED;
        velocity.z = direction.z * SPEED;
    } else {
        // 減速
        velocity.x = 0.0f;
        velocity.z = 0.0f;
    }

    set_velocity(velocity);
    move_and_slide();
}