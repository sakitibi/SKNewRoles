#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/multi_mesh_instance3d.hpp>
#include <godot_cpp/classes/multi_mesh.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/classes/box_mesh.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>

namespace godot {
    // ブロックのメッシュ・マテリアルキャッシュ用構造体
    struct BlockMeshData {
        Ref<Mesh> mesh;
        Ref<Material> material;
        bool valid = false;
    };

    class ChunkMeshBuilder {
        private:
            static int get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z);
            
            // 指定した .tscn から Mesh と Material を読み込んでキャッシュから返す
            static BlockMeshData get_block_mesh_data(const String &scene_path);

            // MultiMeshInstance3D を生成してノードに追加する関数
            static void build_multimesh_for_block(Node3D *parent_node, const String &scene_path, const Vector<Vector3> &positions);

            // Minecraftのブロック名と Godot プレハブ (.tscn) の対応表を取得
            static const HashMap<String, String>& get_block_scene_map();

        public:
            static void build_mesh_and_collision(Node3D *parent_node, const Dictionary &chunk_nbt);
    };
}