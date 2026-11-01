#include "combat_registry.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

CombatRegistry *CombatRegistry::singleton_ = nullptr;

CombatRegistry::CombatRegistry() {
    if (singleton_ == nullptr) {
        singleton_ = this;
    }
    // デフォルトのダメージ設定を確実に登録
    weapon_damages_["iron_sword"] = 6;
    UtilityFunctions::print("[CombatRegistry] ⚔️ CombatRegistry が初期化され、iron_sword = 6 が登録されました。");
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
    UtilityFunctions::print(vformat("[CombatRegistry] 武器ダメージ登録: %s = %d", item_id, damage));
}

uint32_t CombatRegistry::get_weapon_damage(const String &item_id) const {
    std::string id = item_id.utf8().get_data();
    
    auto it = weapon_damages_.find(id);
    if (it != weapon_damages_.end()) {
        UtilityFunctions::print(vformat("[CombatRegistry] 🔍 武器ダメージ取得: %s -> %d", item_id, it->second));
        return it->second;
    }

    UtilityFunctions::print(vformat("[CombatRegistry] ⚠️ 未登録の武器ID '%s' のため、デフォルトダメージ 1 を返します。", item_id));
    return 1;
}