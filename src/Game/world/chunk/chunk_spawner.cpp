#include "chunk_spawner.h"
#include "../../../Blocks/falling_block.h"
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkSpawner::spawn_falling_block(Node3D *parent_node, const Vector3 &spawn_pos, const String &block_type) {
    if (!parent_node) return;

    Ref<PackedScene> falling_scene = ResourceLoader::get_singleton()->load("res://FallingBlock.tscn");
    if (falling_scene.is_null()) {
        UtilityFunctions::printerr("[ChunkManager ERROR] FallingBlock.tscn Failed to load");
        return;
    }

    SNR2FallingBlock *block = Object::cast_to<SNR2FallingBlock>(falling_scene->instantiate());
    if (block != nullptr) {
        block->set_global_position(spawn_pos);
        block->set_block_type(block_type);
        block->connect("block_landed", Callable(parent_node, "_on_block_landed"));

        parent_node->add_child(block);
        UtilityFunctions::print(vformat("[ChunkManager] Falling block (%s) was generated: ", block_type), spawn_pos);
    }
}