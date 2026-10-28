#include "combat_registry.h"

using namespace godot;

CombatRegistry *CombatRegistry::singleton_ = nullptr;

CombatRegistry::CombatRegistry() {
    singleton_ = this;
    // デフォルトのダメージ設定
    weapon_damages_["iron_sword"] = 6;
}

CombatRegistry::~CombatRegistry() {
    if (singleton_ == this) {
        singleton_ = nullptr;
    }
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
    weapon_damages_[id] = damage;
}

uint32_t CombatRegistry::get_weapon_damage(const String &item_id) const {
    std::string id = item_id.utf8().get_data();
    auto it = weapon_damages_.find(id);
    if (it != weapon_damages_.end()) {
        it->second;
    }
    return 1;
}