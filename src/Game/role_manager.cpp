#include "role_manager.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <algorithm>
#include <random>
#include <chrono>
#include <vector>

using namespace godot;

void RoleManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("assign_roles", "player_ids", "role_counts"), &RoleManager::assign_roles);
}

RoleManager::RoleManager() {}
RoleManager::~RoleManager() {}

Dictionary RoleManager::assign_roles(Array player_ids, Dictionary role_counts) {
    Dictionary result;
    int total_players = player_ids.size();

    if (total_players == 0) {
        return result;
    }

    // 役職のプールを作成
    std::vector<int> role_pool;

    // Dictionary で指定された役職と人数をプールに追加
    Array keys = role_counts.keys();
    for (int i = 0; i < keys.size(); ++i) {
        int role_id = keys[i];
        int count = role_counts[keys[i]];

        for (int c = 0; c < count && role_pool.size() < static_cast<size_t>(total_players); ++c) {
            role_pool.push_back(role_id);
        }
    }

    // 定員に達していない場合は、残りを「村人」で埋める
    while (role_pool.size() < static_cast<size_t>(total_players)) {
        role_pool.push_back(Role::CITIZEN);
    }

    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::shuffle(role_pool.begin(), role_pool.end(), std::default_random_engine(seed));

    for (int i = 0; i < total_players; ++i) {
        String player_id = player_ids[i];
        int assigned_role = role_pool[i];
        int assigned_faction = Faction::CITIZEN_FACTION;

        // 役職に応じた陣営の判定
        if (assigned_role == Role::WEREWOLF) {
            assigned_faction = Faction::WEREWOLF_FACTION;
        } else {
            assigned_faction = Faction::CITIZEN_FACTION;
        }

        Dictionary player_data;
        player_data["role"] = assigned_role;
        player_data["faction"] = assigned_faction;

        result[player_id] = player_data;
    }

    return result;
}