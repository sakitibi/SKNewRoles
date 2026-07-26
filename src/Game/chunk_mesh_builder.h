#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/multi_mesh_instance3d.hpp>
#include <godot_cpp/classes/multi_mesh.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/box_shape3d.hpp>
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

            static void build_chunk_mesh(
                Node3D *parent_node, 
                const HashMap<String, Vector<Vector3>> &categorized_positions
            );
    };
}