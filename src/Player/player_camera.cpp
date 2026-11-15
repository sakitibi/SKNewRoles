#include "player_camera.h"
#include "player.h"
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/input_event_key.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

PlayerCamera::PlayerCamera() {}
PlayerCamera::~PlayerCamera() {}

void PlayerCamera::setup(Camera3D *p_camera) {
    camera = p_camera;
    update_transform();
}

void PlayerCamera::cycle_camera_mode() {
    current_camera_mode = static_cast<CameraMode>((current_camera_mode + 1) % 3);
    update_transform();

    const char* mode_str = "";
    switch (current_camera_mode) {
        case FIRST_PERSON: mode_str = "First Person"; break;
        case THIRD_PERSON_BACK: mode_str = "Third Person Back"; break;
        case THIRD_PERSON_FRONT: mode_str = "Third Person Front"; break;
        default: break;
    }
    UtilityFunctions::print(vformat("[PlayerCamera] Camera mode changed to: %s", mode_str));
}

void PlayerCamera::update_transform() {
    if (!camera) return;

    Vector3 pos(0.0f, 0.6f, 0.0f);
    float y_rot = 0.0f;

    switch (current_camera_mode) {
        case FIRST_PERSON:
            pos = Vector3(0.0f, 0.6f, 0.0f);
            y_rot = 0.0f;
            break;
        case THIRD_PERSON_BACK:
            pos = Vector3(0.0f, 1.0f, 3.0f);
            y_rot = 0.0f;
            break;
        case THIRD_PERSON_FRONT:
            pos = Vector3(0.0f, 1.0f, -3.0f);
            y_rot = Math::deg_to_rad(180.0f);
            break;
    }

    camera->set_position(pos);
    camera->set_rotation(Vector3(camera_rotation_x, y_rot, 0.0f));
}

void PlayerCamera::handle_input(Node3D *player, const Ref<InputEvent> &event, Input *input) {
    if (!player || !input) return;

    // mキーでカメラモード切り替え
    Ref<InputEventKey> key_event = event;
    if (key_event.is_valid() && key_event->is_pressed() && !key_event->is_echo()) {
        if (key_event->get_keycode() == Key::KEY_M) {
            cycle_camera_mode();
        }
    }

    if (input->is_mouse_button_pressed(MouseButton::MOUSE_BUTTON_RIGHT)) {
        Ref<InputEventMouseMotion> mouse_motion = event;
        if (mouse_motion.is_valid()) {
            Vector2 delta = mouse_motion->get_relative();

            player->rotate_y(-delta.x * mouse_sensitivity);

            camera_rotation_x -= delta.y * mouse_sensitivity;
            camera_rotation_x = Math::clamp(camera_rotation_x, -LIMIT_ANGLE_X, LIMIT_ANGLE_X);

            update_transform();
        }
    }
}