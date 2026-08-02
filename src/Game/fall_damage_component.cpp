#include "fall_damage_component.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void FallDamageComponent::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_safe_fall_height"), &FallDamageComponent::get_safe_fall_height);
    ClassDB::bind_method(D_METHOD("set_safe_fall_height", "p_height"), &FallDamageComponent::set_safe_fall_height);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "safe_fall_height"), "set_safe_fall_height", "get_safe_fall_height");

    ClassDB::bind_method(D_METHOD("get_damage_per_block"), &FallDamageComponent::get_damage_per_block);
    ClassDB::bind_method(D_METHOD("set_damage_per_block", "p_damage"), &FallDamageComponent::set_damage_per_block);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "damage_per_block"), "set_damage_per_block", "get_damage_per_block");
}

FallDamageComponent::FallDamageComponent() {}
FallDamageComponent::~FallDamageComponent() {}

void FallDamageComponent::process_fall_damage(CharacterBody3D *player) {
    if (!player) return;

    Vector3 current_pos = player->get_global_position();

    if (!player->is_on_floor()) {
        if (!was_in_air) {
            was_in_air = true;
            fall_start_y = current_pos.y;
        } else {
            // 滞空中の最高到達点を記録
            if (current_pos.y > fall_start_y) {
                fall_start_y = current_pos.y;
            }
        }
    } else {
        if (was_in_air) {
            float fall_distance = fall_start_y - current_pos.y;

            if (fall_distance > safe_fall_height) {
                int damage = static_cast<int>((fall_distance - safe_fall_height) * damage_per_block);
                if (damage > 0) {
                    if (player->has_method("take_damage")) {
                        player->call("take_damage", damage);
                    }
                    UtilityFunctions::print("[FallDamageComponent] Fall damage: ", damage, " (Distance: ", fall_distance, "m)");
                }
            }

            was_in_air = false;
            fall_start_y = current_pos.y;
        }
    }
}