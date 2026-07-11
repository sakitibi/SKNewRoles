#include "lobby_manager.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void LobbyManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_other_player_prefab"), &LobbyManager::get_other_player_prefab);
    ClassDB::bind_method(D_METHOD("set_other_player_prefab", "prefab"), &LobbyManager::set_other_player_prefab);
    ClassDB::bind_method(D_METHOD("update_other_player_position", "player_id", "x", "y"), &LobbyManager::update_other_player_position);

    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "other_player_prefab", PROPERTY_HINT_RESOURCE_TYPE, "PackedScene"), "set_other_player_prefab", "get_other_player_prefab");
}

LobbyManager::LobbyManager() {}
LobbyManager::~LobbyManager() {}

void LobbyManager::_ready() {
    if (has_node("MyPlayer")) {
        my_player = get_node<Node2D>("MyPlayer");
    }
}

void LobbyManager::set_other_player_prefab(const Ref<PackedScene> &p_prefab) {
    other_player_prefab = p_prefab;
}

Ref<PackedScene> LobbyManager::get_other_player_prefab() const {
    return other_player_prefab;
}

void LobbyManager::update_other_player_position(const String &player_id, float x, float y) {
    if (other_players.has(player_id)) {
        Node2D* player_node = other_players[player_id];
        if (player_node) {
            player_node->set_position(Vector2(x, y));
        }
    } else {
        if (other_player_prefab.is_null()) return;

        // C++ 側で高速にインスタンス化
        Node* instance = other_player_prefab->instantiate();
        Node2D* new_player = Object::cast_to<Node2D>(instance);
        if (new_player) {
            new_player->set_position(Vector2(x, y));
            new_player->set_name(String("Player_") + player_id);
            add_child(new_player);
            other_players[player_id] = new_player;
        }
    }
}