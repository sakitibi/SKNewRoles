#include "player.h"
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/input.hpp>
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
    ProjectSettings *settings = ProjectSettings::get_singleton();
    gravity = settings->get_setting("physics/3d/default_gravity");

    Node *node = get_node_or_null(NodePath("Camera3D"));
    if (node != nullptr) {
        camera = Object::cast_to<Camera3D>(node);
    }
}

void SNR2Player::_input(const Ref<InputEvent> &event) {
    Input *input = Input::get_singleton();

    if (input->is_mouse_button_pressed(MouseButton::MOUSE_BUTTON_RIGHT)) {
        
        Ref<InputEventMouseMotion> mouse_motion = event;
        if (mouse_motion.is_valid()) {
            Vector2 delta = mouse_motion->get_relative();

            rotation_y -= delta.x * mouse_sensitivity;
            rotation_y = Math::clamp(rotation_y, -LIMIT_ANGLE_RAD, LIMIT_ANGLE_RAD);

            rotation_x -= delta.y * mouse_sensitivity;
            rotation_x = Math::clamp(rotation_x, -LIMIT_ANGLE_RAD, LIMIT_ANGLE_RAD);

            set_rotation(Vector3(0, rotation_y, 0));

            if (camera != nullptr) {
                camera->set_rotation(Vector3(rotation_x, 0, 0));
            } else {
                set_rotation(Vector3(rotation_x, rotation_y, 0));
            }
        }
    }
}

void SNR2Player::_physics_process(double delta) {
    Vector3 velocity = get_velocity();

    if (!is_on_floor()) {
        velocity.y -= gravity * (float)delta;
    }

    Input *input = Input::get_singleton();

    bool is_jump_pressed = input->is_key_pressed(KEY_SPACE) || input->is_action_just_pressed("ui_accept");
    if (is_jump_pressed && is_on_floor()) {
        velocity.y = JUMP_VELOCITY;
    }

    Vector2 input_dir = Vector2(0, 0);

    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) {
        input_dir.x += 1.0f;
    }
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) {
        input_dir.x -= 1.0f;
    }

    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) {
        input_dir.y += 1.0f;
    }
    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) {
        input_dir.y -= 1.0f;
    }

    if (input_dir.length_squared() > 0) {
        input_dir = input_dir.normalized();
    }

    Vector3 direction = get_global_transform().basis.xform(Vector3(input_dir.x, 0, input_dir.y)).normalized();

    if (direction != Vector3(0, 0, 0)) {
        velocity.x = direction.x * SPEED;
        velocity.z = direction.z * SPEED;
    } else {
        velocity.x = UtilityFunctions::move_toward(velocity.x, 0.0f, SPEED);
        velocity.z = UtilityFunctions::move_toward(velocity.z, 0.0f, SPEED);
    }

    set_velocity(velocity);
    move_and_slide();
}