#include "RoleManager.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <algorithm>
#include <random>
#include <chrono>

using namespace godot;

void RoleManager::_bind_methods() {
    // C#側から呼び出せるようにメソッドと列挙型を登録
    ClassDB::bind_method(D_METHOD("assign_roles", "player_ids", "werewolf_count"), &RoleManager::assign_roles);
}

RoleManager::RoleManager() {}
RoleManager::~RoleManager() {}

Dictionary RoleManager::assign_roles(Array player_ids, int werewolf_count) {
    Dictionary result;
    int total_players = player_ids.size();

    if (total_players == 0) {
        return result;
    }

    // 1. 役職のプールを作成
    std::vector<int> role_pool;

    // 指定された数だけ人狼を追加
    for (int i = 0; i < werewolf_count && i < total_players; ++i) {
        role_pool.push_back(Role::WEREWOLF);
    }

    // 残りの人数分を村人（または他の役職）で埋める
    while (role_pool.size() < static_cast<size_t>(total_players)) {
        role_pool.push_back(Role::CITIZEN);
    }

    // 2. C++ の C++11 乱数エンジンで厳密にフィッシャー–イェーツ・シャッフル
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::shuffle(role_pool.begin(), role_pool.end(), std::default_random_engine(seed));

    // 3. 各プレイヤーに役職と陣営を割り当てて Dictionary 化
    for (int i = 0; i < total_players; ++i) {
        String player_id = player_ids[i];
        int assigned_role = role_pool[i];
        int assigned_faction = Faction::CITIZEN_FACTION;

        // 役職に応じた陣営の自動決定
        if (assigned_role == Role::WEREWOLF) {
            assigned_faction = Faction::WEREWOLF_FACTION;
        } else if (assigned_role == Role::MADMAN) {
            assigned_faction = Faction::NEUTRAL_FACTION;
        } else {
            assigned_faction = Faction::CITIZEN_FACTION;
        }

        // プレイヤーごとの情報辞書
        Dictionary player_data;
        player_data["role"] = assigned_role;
        player_data["faction"] = assigned_faction;

        result[player_id] = player_data;
    }
    return result;
}