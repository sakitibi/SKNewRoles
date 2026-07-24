#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>

namespace godot {

    class ChunkMeshBuilder {
        private:
            // NBTデータからのパレットインデックス抽出ユーティリティ
            static int get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z);

        public:
            // NBT辞書から一括で MeshInstance3D と CollisionShape3D を生成して親ノードに追加する
            static void build_mesh_and_collision(Node3D *parent_node, const Dictionary &chunk_nbt);
    };
}