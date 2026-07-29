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
        Ref<Mesh> mesh;
        Vector<Ref<Material>> materials;
        bool valid = false;
    };

    class BlockMeshCache : public Object {
        GDCLASS(BlockMeshCache, Object)

        private:
            static Transform3D get_relative_transform(Node3D *root, Node3D *target);

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