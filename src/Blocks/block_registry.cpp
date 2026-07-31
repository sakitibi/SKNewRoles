#include "block_registry.h"

using namespace godot;

HashMap<String, String> BlockRegistry::block_scene_map;

BlockRegistry::BlockRegistry() {}
BlockRegistry::~BlockRegistry() {}

void BlockRegistry::_bind_methods() {
    ClassDB::bind_static_method("BlockRegistry", D_METHOD("register_block", "block_id", "scene_path"), &BlockRegistry::register_block);
    ClassDB::bind_static_method("BlockRegistry", D_METHOD("set_block_scene_map", "map"), &BlockRegistry::set_block_scene_map);
    ClassDB::bind_static_method("BlockRegistry", D_METHOD("get_block_scene_map"), &BlockRegistry::get_block_scene_map_dict);
    ClassDB::bind_static_method("BlockRegistry", D_METHOD("clear_block_map"), &BlockRegistry::clear_block_map);
    ClassDB::bind_static_method("BlockRegistry", D_METHOD("has_block", "block_id"), &BlockRegistry::has_block); // 👈 追加
}

const HashMap<String, String>& BlockRegistry::get_block_scene_map() {
    if (block_scene_map.is_empty()) {
        block_scene_map["minecraft:grass_block"]  = "res://Scenes/Prefabs/Blocks/GrassBlock.tscn";
        block_scene_map["minecraft:dirt"]         = "res://Scenes/Prefabs/Blocks/Dirt.tscn";
        block_scene_map["minecraft:coarse_dirt"]  = "res://Scenes/Prefabs/Blocks/CoarseDirt.tscn";
        block_scene_map["minecraft:dirt_path"]    = "res://Scenes/Prefabs/Blocks/DirtPath.tscn";
        block_scene_map["minecraft:stone"]        = "res://Scenes/Prefabs/Blocks/Stone.tscn";
        block_scene_map["minecraft:stone_bricks"] = "res://Scenes/Prefabs/Blocks/StoneBricks.tscn";
        block_scene_map["minecraft:andsite"]      = "res://Scenes/Prefabs/Blocks/Andsite.tscn";
        block_scene_map["minecraft:diorite"]      = "res://Scenes/Prefabs/Blocks/Diorite.tscn";
        block_scene_map["minecraft:granite"]      = "res://Scenes/Prefabs/Blocks/Granite.tscn";
        block_scene_map["minecraft:oak_planks"]   = "res://Scenes/Prefabs/Blocks/OakPlanks.tscn";
        block_scene_map["minecraft:gold_block"]   = "res://Scenes/Prefabs/Blocks/GoldBlock.tscn";
        block_scene_map["minecraft:gravel"]       = "res://Scenes/Prefabs/Blocks/Gravel.tscn";
    }
    return block_scene_map;
}

void BlockRegistry::register_block(const String &block_id, const String &scene_path) {
    get_block_scene_map();
    block_scene_map[block_id] = scene_path;
}

void BlockRegistry::set_block_scene_map(const Dictionary &p_map) {
    block_scene_map.clear();
    Array keys = p_map.keys();
    for (int i = 0; i < keys.size(); ++i) {
        String key = keys[i];
        String val = p_map[key];
        block_scene_map[key] = val;
    }
}

Dictionary BlockRegistry::get_block_scene_map_dict() {
    const HashMap<String, String> &map = get_block_scene_map();
    Dictionary dict;
    for (const auto &E : map) {
        dict[E.key] = E.value;
    }
    return dict;
}

void BlockRegistry::clear_block_map() {
    block_scene_map.clear();
}

bool BlockRegistry::has_block(const String &block_id) {
    const HashMap<String, String> &map = get_block_scene_map();
    return map.has(block_id);
}