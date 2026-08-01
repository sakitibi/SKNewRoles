#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/mesh.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/templates/vector.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>

namespace godot {
    struct BlockMeshData {
        Vector<Ref<Material>> materials;
        Vector<PackedVector3Array> face_vertices;
        bool valid = false;
    };

    class BlockMeshCache : public Object {
        GDCLASS(BlockMeshCache, Object)
        private:
            static const char* FACE_NODE_NAMES[6];
            static HashMap<String, BlockMeshData> mesh_cache;
            static HashMap<String, Ref<Material>> material_dedup_map;
        protected:
            static void _bind_methods();

        public:
            BlockMeshCache();
            ~BlockMeshCache();

            static void preload_block_meshes();
            static BlockMeshData get_block_mesh_data(const String &scene_path);
            static void clear_cache();
    };
}