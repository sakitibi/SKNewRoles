#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/multi_mesh_instance3d.hpp>
#include <godot_cpp/classes/multi_mesh.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/box_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/classes/standard_material3d.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>

namespace godot {
    struct BlockMeshData {
        Ref<Mesh> mesh;
        Vector<Ref<Material>> materials;
        bool valid = false;
    };

    // チャンク全体の構築用データ（サブスレッドで生成）
    struct BuiltChunkData {
        // ブロック種類ごとの MultiMesh
        HashMap<String, Ref<MultiMesh>> multimeshes;
        // チャンク全体のコリジョン用ポリゴン頂点
        PackedVector3Array collision_faces;
    };

    class ChunkMeshBuilder {
        private:
            static int get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z);

        public:
            static const HashMap<String, String>& get_block_scene_map();
            static void preload_block_meshes();
            static BlockMeshData get_block_mesh_data(const String &scene_path);

            static HashMap<String, Vector<Vector3>> parse_chunk_positions(
                const Dictionary &chunk_data, 
                int min_section_y = -4, 
                int max_section_y = 19
            );

            // サブスレッドで実行可能：MultiMeshのリソースデータとコリジョン頂点を事前にビルド
            static BuiltChunkData build_chunk_data_async(
                const HashMap<String, Vector<Vector3>> &categorized_positions
            );

            // メインスレッドで実行：作成済みのデータからノードを生成して追加
            static void apply_chunk_data_to_node(
                Node3D *parent_node, 
                const BuiltChunkData &built_data
            );
    };
}