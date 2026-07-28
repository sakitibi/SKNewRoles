#include "chunk_block_editor.h"
#include "chunk_mesh_builder.h"

#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>

using namespace godot;

void ChunkBlockEditor::_bind_methods() {
    ClassDB::bind_method(D_METHOD("add_block_at_world_pos", "world_pos", "block_type"), &ChunkBlockEditor::add_block_at_world_pos, DEFVAL("stone"));
    ClassDB::bind_method(D_METHOD("rebuild_chunk_mesh", "chunk_coord"), &ChunkBlockEditor::rebuild_chunk_mesh);
}

void ChunkBlockEditor::add_block_at_world_pos(
    HashMap<Vector2i, Node3D*> &loaded_chunks,
    HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map,
    float chunk_size,
    const Vector3 &world_pos,
    const String &block_type
) {
    int gx = Math::floor(world_pos.x);
    int gy = Math::floor(world_pos.y);
    int gz = Math::floor(world_pos.z);

    int chunk_x = static_cast<int>(std::floor((float)gx / chunk_size));
    int chunk_z = static_cast<int>(std::floor((float)gz / chunk_size));
    Vector2i target_coord(chunk_x, chunk_z);

    Vector3 local_block_pos(
        gx - (chunk_x * chunk_size) + 0.5f,
        gy + 0.5f,
        gz - (chunk_z * chunk_size) + 0.5f
    );

    if (!chunk_block_data_map.has(target_coord)) {
        chunk_block_data_map[target_coord] = HashMap<String, Vector<Vector3>>();
    }

    chunk_block_data_map[target_coord][block_type].push_back(local_block_pos);

    UtilityFunctions::print(vformat("[ChunkBlockEditor] Chunk (%d, %d) Block (%s) Added (Local: %.1f, %.1f, %.1f)", 
        target_coord.x, target_coord.y, block_type, local_block_pos.x, local_block_pos.y, local_block_pos.z));

    rebuild_chunk_mesh(loaded_chunks, chunk_block_data_map, chunk_size, target_coord);
}

void ChunkBlockEditor::rebuild_chunk_mesh(
    HashMap<Vector2i, Node3D*> &loaded_chunks,
    HashMap<Vector2i, HashMap<String, Vector<Vector3>>> &chunk_block_data_map,
    float chunk_size,
    const Vector2i &chunk_coord
) {
    if (!loaded_chunks.has(chunk_coord) || !chunk_block_data_map.has(chunk_coord)) return;

    Node3D *old_chunk_node = loaded_chunks[chunk_coord];

    HashMap<String, Vector<Vector3>> &positions = chunk_block_data_map[chunk_coord];
    BuiltChunkData new_built_data = ChunkMeshBuilder::build_chunk_data_async(positions, false);

    Node3D *new_chunk_node = memnew(Node3D);
    new_chunk_node->set_name(vformat("Chunk_%d_%d", chunk_coord.x, chunk_coord.y));
    new_chunk_node->set_position(Vector3(chunk_coord.x * chunk_size, 0.0f, chunk_coord.y * chunk_size));

    ChunkMeshBuilder::apply_chunk_data_to_node(new_chunk_node, new_built_data);

    if (old_chunk_node && old_chunk_node->get_parent()) {
        old_chunk_node->get_parent()->add_child(new_chunk_node);
        old_chunk_node->queue_free();
    }

    loaded_chunks[chunk_coord] = new_chunk_node;

    UtilityFunctions::print(vformat("[ChunkBlockEditor] Chunk (%d, %d) Mesh rebuilt successfully", chunk_coord.x, chunk_coord.y));
}