#include "spectator_component.h"
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

SpectatorComponent::SpectatorComponent() {}
SpectatorComponent::~SpectatorComponent() {}

void SpectatorComponent::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_spectator_mode", "enable"), &SpectatorComponent::set_spectator_mode);
    ClassDB::bind_method(D_METHOD("get_is_spectator"), &SpectatorComponent::get_is_spectator);

    ADD_SIGNAL(MethodInfo("spectator_mode_changed", PropertyInfo(Variant::BOOL, "enabled")));
}

void SpectatorComponent::setup(CharacterBody3D *p_player, Camera3D *p_camera) {
    target_player = p_player;
    camera = p_camera;
    input = Input::get_singleton();
}

void SpectatorComponent::set_spectator_mode(bool p_enable) {
    if (!target_player) return;

    is_spectator = p_enable;

    // メッシュ（姿）の表示 / 非表示切り替え
    Node *mesh_node = target_player->get_node_or_null(NodePath("MeshInstance3D"));
    if (mesh_node) {
        mesh_node->call("set_visible", !p_enable);
    }

    // 衝突判定の無効化 / 有効化
    for (int i = 0; i < target_player->get_child_count(); ++i) {
        CollisionShape3D *col = Object::cast_to<CollisionShape3D>(target_player->get_child(i));
        if (col) {
            col->set_disabled(p_enable);
        }
    }

    emit_signal("spectator_mode_changed", is_spectator);
}

void SpectatorComponent::process_movement(double delta) {
    if (!is_spectator || !target_player || !input) return;

    Vector3 move_dir = Vector3(0, 0, 0);

    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) move_dir.z -= 1.0f;
    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) move_dir.z += 1.0f;
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) move_dir.x -= 1.0f;
    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) move_dir.x += 1.0f;

    if (input->is_key_pressed(KEY_SPACE)) move_dir.y += 1.0f;
    if (input->is_key_pressed(KEY_SHIFT) || input->is_key_pressed(KEY_E)) move_dir.y -= 1.0f;

    if (move_dir.length_squared() > 0.0f) {
        move_dir = move_dir.normalized();

        Transform3D cam_transform = (camera != nullptr) ? camera->get_global_transform() : target_player->get_global_transform();

        Vector3 forward = -cam_transform.basis.get_column(2);
        Vector3 right = cam_transform.basis.get_column(0);
        Vector3 up = Vector3(0, 1, 0);

        Vector3 target_velocity = (forward * -move_dir.z) + (right * move_dir.x) + (up * move_dir.y);
        target_player->set_velocity(target_velocity * SPECTATOR_SPEED);
    } else {
        target_player->set_velocity(Vector3(0, 0, 0));
    }

    target_player->set_position(target_player->get_position() + target_player->get_velocity() * static_cast<float>(delta));
}