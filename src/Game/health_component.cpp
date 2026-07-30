#include "health_component.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <algorithm>

using namespace godot;

HealthComponent::HealthComponent() {}
HealthComponent::~HealthComponent() {}

void HealthComponent::_bind_methods() {
    // Property bindings
    ClassDB::bind_method(D_METHOD("set_max_hp", "max_hp"), &HealthComponent::set_max_hp);
    ClassDB::bind_method(D_METHOD("get_max_hp"), &HealthComponent::get_max_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_hp"), "set_max_hp", "get_max_hp");

    ClassDB::bind_method(D_METHOD("set_current_hp", "hp"), &HealthComponent::set_current_hp);
    ClassDB::bind_method(D_METHOD("get_current_hp"), &HealthComponent::get_current_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "current_hp"), "set_current_hp", "get_current_hp");

    ClassDB::bind_method(D_METHOD("is_dead"), &HealthComponent::get_is_dead);

    // Method bindings
    ClassDB::bind_method(D_METHOD("take_damage", "amount"), &HealthComponent::take_damage);
    ClassDB::bind_method(D_METHOD("heal", "amount"), &HealthComponent::heal);
    ClassDB::bind_method(D_METHOD("die"), &HealthComponent::die);
    ClassDB::bind_method(D_METHOD("respawn", "health_percentage"), &HealthComponent::respawn, DEFVAL(100));

    // Signal bindings
    ADD_SIGNAL(MethodInfo("hp_changed", PropertyInfo(Variant::INT, "current_hp"), PropertyInfo(Variant::INT, "max_hp")));
    ADD_SIGNAL(MethodInfo("died"));
    ADD_SIGNAL(MethodInfo("respawned"));
}

void HealthComponent::set_max_hp(int p_max_hp) {
    max_hp = std::max(1, p_max_hp);
    if (current_hp > max_hp) {
        current_hp = max_hp;
    }
}

int HealthComponent::get_max_hp() const {
    return max_hp;
}

void HealthComponent::set_current_hp(int p_hp) {
    if (is_dead && p_hp > 0) {
        is_dead = false;
    }

    current_hp = std::clamp(p_hp, 0, max_hp);
    emit_signal("hp_changed", current_hp, max_hp);

    if (current_hp <= 0 && !is_dead) {
        die();
    }
}

int HealthComponent::get_current_hp() const {
    return current_hp;
}

void HealthComponent::take_damage(int p_amount) {
    if (is_dead || p_amount <= 0) return;

    UtilityFunctions::print("[Damage] Applied damage: ", p_amount);
    set_current_hp(current_hp - p_amount);
}

void HealthComponent::heal(int p_amount) {
    if (is_dead || p_amount <= 0) return;

    UtilityFunctions::print("[Heal] Healed amount: ", p_amount);
    set_current_hp(current_hp + p_amount);
}

void HealthComponent::die() {
    if (is_dead) return;

    is_dead = true;
    current_hp = 0;

    UtilityFunctions::print("[Death] HealthComponent: Entity has died.");
    
    emit_signal("hp_changed", current_hp, max_hp);
    emit_signal("died");
}

void HealthComponent::respawn(int p_health_percentage) {
    if (!is_dead && current_hp > 0) return;

    is_dead = false;
    float pct = std::clamp(p_health_percentage, 1, 100) / 100.0f;
    current_hp = static_cast<int>(max_hp * pct);

    UtilityFunctions::print("[Respawn] HealthComponent: Respawned. HP: ", current_hp, "/", max_hp);

    emit_signal("hp_changed", current_hp, max_hp);
    emit_signal("respawned");
}