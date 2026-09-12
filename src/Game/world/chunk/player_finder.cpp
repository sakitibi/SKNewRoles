#include "player_finder.h"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/core/object.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

Node3D *PlayerFinder::find_local_player(
    Node *context_node,
    const NodePath &player_path, uint64_t &io_player_instance_id
) {
    if (!context_node) return nullptr;

    if (io_player_instance_id != 0) {
        if (UtilityFunctions::is_instance_id_valid(io_player_instance_id)) {
            Object *obj = ObjectDB::get_instance(io_player_instance_id);
            if (obj) {
                Node3D *p = Object::cast_to<Node3D>(obj);
                if (p && p->is_inside_tree()) return p;
            }
        }
        io_player_instance_id = 0;
    }

    if (!player_path.is_empty()) {
        Node *node = context_node->get_node_or_null(player_path);
        if (node) {
            Node3D *p = Object::cast_to<Node3D>(node);
            if (p) {
                io_player_instance_id = p->get_instance_id();
                return p;
            }
        }
    }

    SceneTree *st = context_node->get_tree();
    if (st) {
        Array players = st->get_nodes_in_group("player");
        if (players.size() > 0) {
            Node3D *p = Object::cast_to<Node3D>(players[0]);
            if (p) {
                io_player_instance_id = p->get_instance_id();
                return p;
            }
        }

        Node *root = st->get_current_scene();
        if (root) {
            Node *p_node = root->find_child("MyPlayer", true, false);
            if (!p_node) p_node = root->find_child("Player", true, false);
            if (p_node) {
                Node3D *p = Object::cast_to<Node3D>(p_node);
                if (p) {
                    io_player_instance_id = p->get_instance_id();
                    return p;
                }
            }
        }
    }

    return nullptr;
}