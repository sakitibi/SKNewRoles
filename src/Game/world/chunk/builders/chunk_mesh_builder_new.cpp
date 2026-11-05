#include "chunk_mesh_builder_new.h"
#include "chunk_mesh_processor.h"
#include "../chunk_collision_builder.h"
#include <unordered_map>
#include <vector>
#include <string>

using namespace godot;

PureChunkData ChunkMeshBuilderNew::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions
) {
    std::unordered_map<std::string, std::vector<Vector3>> native_categorized;
    native_categorized.reserve(categorized_positions.size());

    for (const auto &E : categorized_positions) {
        std::string b_id = std::string(E.key.utf8().get_data());
        const Vector<Vector3> &godot_pos_vec = E.value;
        std::vector<Vector3> pos_vec;
        pos_vec.reserve(godot_pos_vec.size());
        for (int i = 0; i < godot_pos_vec.size(); ++i) {
            pos_vec.push_back(godot_pos_vec[i]);
        }
        if (!pos_vec.empty()) {
            native_categorized[b_id] = std::move(pos_vec);
        }
    }

    PureChunkData result = ChunkMeshProcessor::process_chunk(native_categorized);

    result.collision_faces = ChunkCollisionBuilder::build_collision_faces(categorized_positions);

    return result;
}