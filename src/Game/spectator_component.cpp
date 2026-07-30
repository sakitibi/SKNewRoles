#include "spectator_component.h"
#include <godot_cpp/classes/node3d.hpp>
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

    // 移動速度のリセット
    target_player->set_velocity(Vector3(0, 0, 0));

    Node *mesh_node = target_player->get_node_or_null(NodePath("MeshInstance3D"));
    if (mesh_node) {
        set_node_visible_recursive(mesh_node, !p_enable);
    } else {
        for (int i = 0; i < target_player->get_child_count(); ++i) {
            Node *child = target_player->get_child(i);
            if (child && child->is_class("MeshInstance3D")) {
                set_node_visible_recursive(child, !p_enable);
            }
        }
    }

    for (int i = 0; i < target_player->get_child_count(); ++i) {
        CollisionShape3D *col = Object::cast_to<CollisionShape3D>(target_player->get_child(i));
        if (col) {
            col->set_disabled(p_enable);
        }
    }

    emit_signal("spectator_mode_changed", is_spectator);
}

void SpectatorComponent::set_node_visible_recursive(Node *p_node, bool p_visible) {
    if (!p_node) return;

    Node3D *node3d = Object::cast_to<Node3D>(p_node);
    if (node3d) {
        node3d->set_visible(p_visible);
    }
}

void SpectatorComponent::process_movement(double delta) {
    if (!is_spectator || !target_player || !input) return;

    Vector3 move_dir = Vector3(0, 0, 0);

    // キー入力判定
    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) move_dir.z -= 1.0f;
    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) move_dir.z += 1.0f;
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) move_dir.x -= 1.0f;
    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) move_dir.x += 1.0f;

    // 上下移動 (Spaceで上昇, Shift/Eで下降)
    if (input->is_key_pressed(KEY_SPACE)) move_dir.y += 1.0f;
    if (input->is_key_pressed(KEY_SHIFT) || input->is_key_pressed(KEY_E)) move_dir.y -= 1.0f;

    if (move_dir.length_squared() > 0.0f) {
        move_dir = move_dir.normalized();

        // カメラまたはプレイヤーの Transform 取得
        Transform3D cam_transform = (camera != nullptr) ? camera->get_global_transform() : target_player->get_global_transform();

        Vector3 forward = -cam_transform.basis.get_column(2);
        Vector3 right = cam_transform.basis.get_column(0);
        Vector3 up = Vector3(0, 1, 0);

        Vector3 target_velocity = (forward * -move_dir.z) + (right * move_dir.x) + (up * move_dir.y);

        Vector3 new_global_pos = target_player->get_global_position() + (target_velocity * SPECTATOR_SPEED * static_cast<float>(delta));
        target_player->set_global_position(new_global_pos);
    }

    // 物理移動速度を 0 に保ち、重力や慣性による位置ずれを防止
    target_player->set_velocity(Vector3(0, 0, 0));
}