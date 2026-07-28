#include "player.h"
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void SNR2Player::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_max_hp"), &SNR2Player::get_max_hp);
    ClassDB::bind_method(D_METHOD("set_max_hp", "p_hp"), &SNR2Player::set_max_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_hp"), "set_max_hp", "get_max_hp");

    ClassDB::bind_method(D_METHOD("get_current_hp"), &SNR2Player::get_current_hp);
    ClassDB::bind_method(D_METHOD("set_current_hp", "p_hp"), &SNR2Player::set_current_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "current_hp"), "set_current_hp", "get_current_hp");

    ClassDB::bind_method(D_METHOD("take_damage", "amount"), &SNR2Player::take_damage);
    ClassDB::bind_method(D_METHOD("heal", "amount"), &SNR2Player::heal);

    ADD_SIGNAL(MethodInfo("hp_changed", PropertyInfo(Variant::INT, "current_hp"), PropertyInfo(Variant::INT, "max_hp")));
}

SNR2Player::SNR2Player() {
    gravity = 9.8f;
    max_hp = 20;
    current_hp = 20;
}

SNR2Player::~SNR2Player() {}

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

void SNR2Player::set_max_hp(int p_hp) {
    max_hp = p_hp;
    if (current_hp > max_hp) {
        current_hp = max_hp;
    }
    emit_signal("hp_changed", current_hp, max_hp);
}

int SNR2Player::get_max_hp() const { return max_hp; }

void SNR2Player::set_current_hp(int p_hp) {
    current_hp = Math::clamp(p_hp, 0, max_hp);
    emit_signal("hp_changed", current_hp, max_hp);
}

int SNR2Player::get_current_hp() const { return current_hp; }

void SNR2Player::take_damage(int amount) {
    if (amount <= 0) return;
    current_hp = Math::max(0, current_hp - amount);
    emit_signal("hp_changed", current_hp, max_hp);

    if (current_hp <= 0) {
        UtilityFunctions::print("[Player] The player's HP has dropped to 0");
    }
}

void SNR2Player::heal(int amount) {
    if (amount <= 0) return;
    current_hp = Math::min(max_hp, current_hp + amount);
    emit_signal("hp_changed", current_hp, max_hp);
}

void SNR2Player::_input(const Ref<InputEvent> &event) {
    if (!input) return;

    if (input->is_mouse_button_pressed(MouseButton::MOUSE_BUTTON_RIGHT)) {
        Ref<InputEventMouseMotion> mouse_motion = event;
        if (mouse_motion.is_valid()) {
            Vector2 delta = mouse_motion->get_relative();

            rotate_y(-delta.x * mouse_sensitivity);

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
    Vector3 current_pos = get_global_position();

    // 落下および高度判定
    if (!is_on_floor()) {
        velocity.y -= gravity * (float)delta;

        if (!was_in_air) {
            // 空中に入った瞬間の高さ
            was_in_air = true;
            fall_start_y = current_pos.y;
        } else {
            // ノックバックやジャンプで上昇した場合は最高到達点を更新
            if (current_pos.y > fall_start_y) {
                fall_start_y = current_pos.y;
            }
        }
    } else {
        if (was_in_air) {
            // 落下した総距離（メートル/ブロック数）
            float fall_distance = fall_start_y - current_pos.y;

            if (fall_distance > SAFE_FALL_HEIGHT) {
                float excess_distance = fall_distance - SAFE_FALL_HEIGHT;
                
                // 1m超えるごとに HP 1 のダメージ
                int damage = static_cast<int>(Math::floor(excess_distance)) * DAMAGE_PER_BLOCK;

                if (damage > 0) {
                    take_damage(damage);
                    UtilityFunctions::print("[Player] Fall damage: ", damage, " (Fall distance: ", fall_distance, "m)");
                }
            }

            was_in_air = false;
            fall_start_y = current_pos.y;
        }
    }

    // ジャンプ処理
    bool is_jump_pressed = input->is_key_pressed(KEY_SPACE) || input->is_action_pressed("ui_accept");
    if (is_jump_pressed && is_on_floor()) {
        velocity.y = JUMP_VELOCITY;
    }

    // 移動処理
    Vector2 input_dir = Vector2(0, 0);
    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) input_dir.x += 1.0f;
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) input_dir.x -= 1.0f;
    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) input_dir.y += 1.0f;
    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) input_dir.y -= 1.0f;

    if (input_dir.length_squared() > 0.0f) {
        input_dir = input_dir.normalized();

        Basis basis = get_global_transform().basis;
        Vector3 forward = -basis.get_column(2);
        Vector3 right = basis.get_column(0);

        forward.y = 0.0f;
        right.y = 0.0f;
        forward.normalize();
        right.normalize();

        Vector3 direction = (forward * -input_dir.y + right * input_dir.x).normalized();

        velocity.x = direction.x * SPEED;
        velocity.z = direction.z * SPEED;
    } else {
        velocity.x = 0.0f;
        velocity.z = 0.0f;
    }

    set_velocity(velocity);
    move_and_slide();
}