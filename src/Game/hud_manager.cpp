#include "hud_manager.h"
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void HUDManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_player_path"), &HUDManager::get_player_path);
    ClassDB::bind_method(D_METHOD("set_player_path", "p_path"), &HUDManager::set_player_path);
    ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, "player_path"), "set_player_path", "get_player_path");

    ClassDB::bind_method(D_METHOD("get_label_path"), &HUDManager::get_label_path);
    ClassDB::bind_method(D_METHOD("set_label_path", "p_path"), &HUDManager::set_label_path);
    ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, "label_path"), "set_label_path", "get_label_path");
}

HUDManager::HUDManager() {}
HUDManager::~HUDManager() {}

void HUDManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    if (!label_path.is_empty()) {
        position_label = Object::cast_to<Label>(get_node_or_null(label_path));
    } else {
        position_label = Object::cast_to<Label>(get_node_or_null("PositionLabel"));
    }

    player_node = find_local_player();
}

void HUDManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // プレイヤー未取得の場合は再検索
    if (player_node == nullptr) {
        player_node = find_local_player();
    }

    // Label 未取得の場合は再検索
    if (position_label == nullptr && !label_path.is_empty()) {
        position_label = Object::cast_to<Label>(get_node_or_null(label_path));
    }

    // 座標テキストの更新
    if (player_node != nullptr && position_label != nullptr) {
        Vector3 pos = player_node->get_global_position();
        
        // 小数点第1位までに整形して表示
        String pos_text = String("XYZ: ") + 
                          String::num(pos.x, 1) + ", " + 
                          String::num(pos.y, 1) + ", " + 
                          String::num(pos.z, 1);
        
        position_label->set_text(pos_text);
    }
}

Node3D *HUDManager::find_local_player() {
    if (!player_path.is_empty()) {
        Node *n = get_node_or_null(player_path);
        if (n != nullptr) {
            return Object::cast_to<Node3D>(n);
        }
    }

    SceneTree *tree = get_tree();
    if (tree == nullptr) return nullptr;

    Array players = tree->get_nodes_in_group("LocalPlayer");
    if (players.size() > 0) {
        return Object::cast_to<Node3D>(players[0]);
    }
    return nullptr;
}

void HUDManager::set_player_path(const NodePath &p_path) {
    player_path = p_path;
}

NodePath HUDManager::get_player_path() const {
    return player_path;
}

void HUDManager::set_label_path(const NodePath &p_path) {
    label_path = p_path;
}

NodePath HUDManager::get_label_path() const {
    return label_path;
}