#include "combat_registry.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

CombatRegistry *CombatRegistry::singleton_ = nullptr;
std::unordered_map<std::string, uint32_t> CombatRegistry::weapon_damages_ = {};

CombatRegistry::CombatRegistry() {
    singleton_ = this;
}

CombatRegistry::~CombatRegistry() {
    if (singleton_ == this) {
        singleton_ = nullptr;
    }
    clear_registry();
}

CombatRegistry *CombatRegistry::get_singleton() {
    return singleton_;
}

void CombatRegistry::_bind_methods() {
    ClassDB::bind_method(D_METHOD("register_weapon_damage", "item_id", "damage"), &CombatRegistry::register_weapon_damage);
    ClassDB::bind_method(D_METHOD("get_weapon_damage", "item_id"), &CombatRegistry::get_weapon_damage);
}

void CombatRegistry::register_weapon_damage(const String &item_id, uint32_t damage) {
    std::string id = item_id.utf8().get_data();
    if (!validate_weapon_id(id)) {
        return;
    }
    
    uint32_t safe_damage = calculate_clamped_damage(damage);
    add_weapon(id, safe_damage);
    
    UtilityFunctions::print(vformat("[CombatRegistry] Dynamic Weapon Damage Registration: %s = %d", item_id, safe_damage));
}

uint32_t CombatRegistry::get_weapon_damage(const String &item_id) const {
    std::string id = item_id.utf8().get_data();
    return get_damage(id);
}

void CombatRegistry::add_weapon(const std::string &item_id, uint32_t damage) {
    if (!validate_weapon_id(item_id)) {
        return;
    }
    weapon_damages_[item_id] = calculate_clamped_damage(damage);
}

uint32_t CombatRegistry::get_damage(const std::string &item_id) {
    if (!validate_weapon_id(item_id)) {
        return 1;
    }
    auto it = weapon_damages_.find(item_id);
    if (it != weapon_damages_.end()) {
        return it->second;
    }
    return 1;
}

void CombatRegistry::clear_registry() {
    weapon_damages_.clear();
}