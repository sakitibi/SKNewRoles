#include "role_manager.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <algorithm>
#include <random>
#include <chrono>
#include <vector>

using namespace godot;

void RoleManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("assign_roles", "player_ids", "role_counts", "role_factions"), &RoleManager::assign_roles, DEFVAL(Dictionary()));
}

RoleManager::RoleManager() {}
RoleManager::~RoleManager() {}

Dictionary RoleManager::assign_roles(Array player_ids, Dictionary role_counts, Dictionary role_factions) {
    Dictionary result;
    int total_players = player_ids.size();

    if (total_players == 0) {
        return result;
    }

    std::vector<uint32_t> role_pool;

    Array keys = role_counts.keys();
    for (int i = 0; i < keys.size(); ++i) {
        uint32_t role_id = static_cast<uint32_t>(keys[i]);
        uint32_t count = static_cast<uint32_t>(role_counts[keys[i]]);

        for (uint32_t c = 0; c < count && role_pool.size() < static_cast<size_t>(total_players); ++c) {
            role_pool.push_back(role_id);
        }
    }

    while (role_pool.size() < static_cast<size_t>(total_players)) {
        role_pool.push_back(DefaultRoles::STUDENTS);
    }

    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::shuffle(role_pool.begin(), role_pool.end(), std::default_random_engine(seed));

    for (int i = 0; i < total_players; ++i) {
        String player_id = player_ids[i];
        uint32_t assigned_role = role_pool[i];
        uint32_t assigned_faction = DefaultFactions::STUDENTS_FACTION;

        if (role_factions.has(assigned_role)) {
            assigned_faction = static_cast<uint32_t>(role_factions[assigned_role]);
        } else {
            if (assigned_role == DefaultRoles::WEREWOLF) {
                assigned_faction = DefaultFactions::WEREWOLF_FACTION;
            } else {
                assigned_faction = DefaultFactions::STUDENTS_FACTION;
            }
        }

        Dictionary player_data;
        player_data["role"] = assigned_role;
        player_data["faction"] = assigned_faction;

        result[player_id] = player_data;
    }

    return result;
}