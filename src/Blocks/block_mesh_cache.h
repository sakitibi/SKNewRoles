#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/mesh.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/templates/vector.hpp>

namespace godot {
    struct BlockMeshData {
        Vector<Ref<Material>> materials;
        bool valid = false;
    };

    class BlockMeshCache : public Object {
        GDCLASS(BlockMeshCache, Object)
        private:
            static HashMap<String, BlockMeshData> mesh_cache;
            static HashMap<String, Ref<Material>> material_dedup_map;
        protected:
            static void _bind_methods();

        public:
            BlockMeshCache();
            ~BlockMeshCache();

            static const char* FACE_NODE_NAMES[6];
            static void preload_block_meshes();
            static BlockMeshData get_block_mesh_data(const String &scene_path);
            static void clear_cache();
    };
}