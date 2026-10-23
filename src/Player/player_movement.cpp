#include "player_movement.h"
#include <godot_cpp/classes/viewport.hpp>

using namespace godot;

void PlayerMovement::process_physics(
    CharacterBody3D *body,
    Input *input,
    FallDamageComponent *fall_damage_comp,
    HungerComponent *hunger_comp,
    float delta,
    float gravity,
    float speed,
    float jump_velocity,
    bool is_spectator
) {
    if (!body || !input || is_spectator) return;

    Vector3 velocity = body->get_velocity();

    if (!body->is_on_floor()) {
        velocity.y -= gravity * static_cast<float>(delta);
    }

    if (fall_damage_comp) {
        fall_damage_comp->process_fall_damage(body);
    }

    bool is_jump_pressed = input->is_key_pressed(KEY_SPACE) || input->is_action_pressed("ui_accept");
    if (is_jump_pressed && body->is_on_floor()) {
        velocity.y = jump_velocity;
        if (hunger_comp) {
            hunger_comp->consume_hunger(1);
        }
    }

    Vector2 input_dir = Vector2(0, 0);
    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) input_dir.x += 1.0f;
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) input_dir.x -= 1.0f;
    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) input_dir.y += 1.0f;
    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) input_dir.y -= 1.0f;

    if (input_dir.length_squared() > 0.0f) {
        input_dir = input_dir.normalized();
        Basis basis = body->get_global_transform().basis;
        Vector3 forward = -basis.get_column(2);
        Vector3 right = basis.get_column(0);

        forward.y = 0.0f;
        right.y = 0.0f;
        forward.normalize();
        right.normalize();

        Vector3 direction = (forward * -input_dir.y + right * input_dir.x).normalized();
        velocity.x = direction.x * speed;
        velocity.z = direction.z * speed;
    } else {
        velocity.x = 0.0f;
        velocity.z = 0.0f;
    }

    body->set_velocity(velocity);
    body->move_and_slide();
}