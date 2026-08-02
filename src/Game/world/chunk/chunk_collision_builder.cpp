#include "chunk_collision_builder.h"
#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <cmath>

using namespace godot;

PackedVector3Array ChunkCollisionBuilder::build_collision_faces(
    const HashMap<String, Vector<Vector3>> &categorized_positions
) {
    PackedVector3Array collision_faces;

    HashSet<Vector3i> occupied_blocks;
    for (const auto &E : categorized_positions) {
        const Vector<Vector3> &vec = E.value;
        for (int i = 0; i < vec.size(); ++i) {
            Vector3 pos = vec[i];
            occupied_blocks.insert(Vector3i(
                static_cast<int>(Math::round(pos.x)),
                static_cast<int>(Math::round(pos.y)),
                static_cast<int>(Math::round(pos.z))
            ));
        }
    }

    // ブロックの位置一覧を収集
    Vector<Vector3> all_positions;
    for (const auto &E : categorized_positions) {
        const Vector<Vector3> &vec = E.value;
        for (int i = 0; i < vec.size(); ++i) {
            all_positions.append(vec[i]);
        }
    }

    // 正確なポリゴン頂点定義
    static const Vector3 box_verts[36] = {
        // Top (+Y)
        Vector3(-0.5f, 0.5f, -0.5f), Vector3(0.5f, 0.5f, -0.5f), Vector3(0.5f, 0.5f, 0.5f),
        Vector3(-0.5f, 0.5f, -0.5f), Vector3(0.5f, 0.5f, 0.5f), Vector3(-0.5f, 0.5f, 0.5f),
        // Bottom (-Y)
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(0.5f, -0.5f, 0.5f), Vector3(0.5f, -0.5f, -0.5f),
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(0.5f, -0.5f, -0.5f), Vector3(-0.5f, -0.5f, -0.5f),
        // Front (+Z)
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(-0.5f, 0.5f, 0.5f), Vector3(0.5f, 0.5f, 0.5f),
        Vector3(-0.5f, -0.5f, 0.5f), Vector3(0.5f, 0.5f, 0.5f), Vector3(0.5f, -0.5f, 0.5f),
        // Back (-Z)
        Vector3(0.5f, -0.5f, -0.5f), Vector3(0.5f, 0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f),
        Vector3(0.5f, -0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f), Vector3(-0.5f, -0.5f, -0.5f),
        // Left (-X)
        Vector3(-0.5f, -0.5f, -0.5f), Vector3(-0.5f, 0.5f, -0.5f), Vector3(-0.5f, 0.5f, 0.5f),
        Vector3(-0.5f, -0.5f, -0.5f), Vector3(-0.5f, 0.5f, 0.5f), Vector3(-0.5f, -0.5f, 0.5f),
        // Right (+X)
        Vector3(0.5f, -0.5f, 0.5f), Vector3(0.5f, 0.5f, 0.5f), Vector3(0.5f, 0.5f, -0.5f),
        Vector3(0.5f, -0.5f, 0.5f), Vector3(0.5f, 0.5f, -0.5f), Vector3(0.5f, -0.5f, -0.5f)
    };

    // 周囲が埋まっているブロックのカリングとコリジョン頂点の追加
    for (int i = 0; i < all_positions.size(); ++i) {
        Vector3 pos = all_positions[i];
        Vector3i grid_pos(
            static_cast<int>(Math::round(pos.x)),
            static_cast<int>(Math::round(pos.y)),
            static_cast<int>(Math::round(pos.z))
        );

        bool is_fully_surrounded =
            occupied_blocks.has(grid_pos + Vector3i(1, 0, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(-1, 0, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, 1, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, -1, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, 0, 1)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, 0, -1));

        if (is_fully_surrounded) continue;

        Vector3 offset(pos.x + 0.5f, pos.y + 0.5f, pos.z + 0.5f);
        for (int k = 0; k < 36; ++k) {
            collision_faces.append(box_verts[k] + offset);
        }
    }

    return collision_faces;
}