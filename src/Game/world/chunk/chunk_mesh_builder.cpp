#include "chunk_mesh_builder.h"

#include "builders/chunk_data_parser.h"
#include "builders/chunk_mesh_builder_new.h"
#include "builders/chunk_node_applier.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <chrono>

using namespace godot;

ChunkMeshBuilder::ChunkMeshBuilder() {}
ChunkMeshBuilder::~ChunkMeshBuilder() {}

void ChunkMeshBuilder::_bind_methods() {}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(
    const Dictionary &chunk_data,
    int min_section_y,
    int max_section_y
) {
    return ChunkDataParser::parse_chunk_positions(chunk_data, min_section_y, max_section_y);
}

BuiltChunkData ChunkMeshBuilder::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions,
    bool p_is_initial_load
) {
    auto start_time = std::chrono::high_resolution_clock::now();

    BuiltChunkDataNew newData = ChunkMeshBuilderNew::build_chunk_data_async(categorized_positions, p_is_initial_load);

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();

    UtilityFunctions::print(vformat("Chunk build time: %d ms", (int)duration_ms));

    BuiltChunkData result;
    result.meshes = newData.meshes;
    result.collision_faces = newData.collision_faces;
    return result;
}

void ChunkMeshBuilder::apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkData &built_data) {
    BuiltChunkDataNew newData;
    newData.meshes = built_data.meshes;
    newData.collision_faces = built_data.collision_faces;

    ChunkNodeApplier::apply_chunk_data_to_node(parent_node, newData);
}