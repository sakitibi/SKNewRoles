#include "player_spawner.h"
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void PlayerSpawner::_bind_methods() {
    ClassDB::bind_method(D_METHOD("spawn_player", "parent"), &PlayerSpawner::spawn_player);
    ClassDB::bind_method(D_METHOD("set_player_physics_enabled", "player_instance", "enabled"), &PlayerSpawner::set_player_physics_enabled);
}

Node3D *PlayerSpawner::spawn_player(Node *parent) {
    if (!parent) {
        UtilityFunctions::push_error("[PlayerSpawner] Error: parent is null.");
        return nullptr;
    }

    Ref<PackedScene> player_scene = ResourceLoader::get_singleton()->load("res://Scenes/Prefabs/Player.tscn");
    if (!player_scene.is_valid()) {
        UtilityFunctions::push_error("[PlayerSpawner] Error: Failed to load Player.tscn.");
        return nullptr;
    }

    Node *instantiated = player_scene->instantiate();
    Node3D *player_instance = Object::cast_to<Node3D>(instantiated);
    if (!player_instance) {
        UtilityFunctions::push_error("[PlayerSpawner] Error: Failed to cast instance to Node3D.");
        if (instantiated) {
            instantiated->queue_free();
        }
        return nullptr;
    }

    player_instance->set_name("MyPlayer");
    parent->add_child(player_instance);

    player_instance->set_global_position(Vector3(0, 100, 0));

    set_player_physics_enabled(player_instance, false);

    UtilityFunctions::print("[PlayerSpawner] My player spawned successfully on C++ side. (Pos: 0, 100, 0)");

    return player_instance;
}

void PlayerSpawner::set_player_physics_enabled(Node3D *player_instance, bool enabled) {
    if (!player_instance || !player_instance->is_inside_tree()) {
        UtilityFunctions::push_error("[PlayerSpawner] Warning: player_instance is invalid or outside the tree.");
        return;
    }

    if (player_instance->has_method("set_movement_enabled")) {
        player_instance->call("set_movement_enabled", enabled);
        UtilityFunctions::print(String("[PlayerSpawner] Successfully called set_movement_enabled({0}).").format(Array::make(enabled)));
    } else {
        UtilityFunctions::push_error(String("[PlayerSpawner] Error: Method 'set_movement_enabled' does not exist on this node ({0})!").format(Array::make(player_instance->get_class())));
    }
}