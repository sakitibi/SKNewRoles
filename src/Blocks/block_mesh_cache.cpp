#include "block_mesh_cache.h"
#include "block_registry.h"

#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>

using namespace godot;

BlockMeshCache::BlockMeshCache() {}
BlockMeshCache::~BlockMeshCache() {}

void BlockMeshCache::_bind_methods() {
    ClassDB::bind_static_method("BlockMeshCache", D_METHOD("preload_block_meshes"), &BlockMeshCache::preload_block_meshes);
    ClassDB::bind_static_method("BlockMeshCache", D_METHOD("clear_cache"), &BlockMeshCache::clear_cache);
}

Transform3D BlockMeshCache::get_relative_transform(Node3D *root, Node3D *target) {
    if (!root || !target) return Transform3D();
    if (root == target) return Transform3D();

    Transform3D accumulated_transform = target->get_transform();
    Node *parent = target->get_parent();

    while (parent != nullptr) {
        Node3D *parent_3d = Object::cast_to<Node3D>(parent);
        if (parent_3d) {
            if (parent_3d == root) return accumulated_transform;
            accumulated_transform = parent_3d->get_transform() * accumulated_transform;
        }
        parent = parent->get_parent();
    }
    return accumulated_transform;
}

void BlockMeshCache::preload_block_meshes() {
    const HashMap<String, String> &map = BlockRegistry::get_block_scene_map();
    for (const auto &E : map) {
        get_block_mesh_data(E.value);
    }
}

static HashMap<String, BlockMeshData> mesh_cache;

void BlockMeshCache::clear_cache() {
    mesh_cache.clear();
}

BlockMeshData BlockMeshCache::get_block_mesh_data(const String &scene_path) {
    if (mesh_cache.has(scene_path)) {
        return mesh_cache[scene_path];
    }

    BlockMeshData data;
    if (!ResourceLoader::get_singleton()->exists(scene_path)) {
        mesh_cache[scene_path] = data;
        return data;
    }

    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    if (scene.is_null()) {
        mesh_cache[scene_path] = data;
        return data;
    }

    Node *inst = scene->instantiate();
    Node3D *root_3d = Object::cast_to<Node3D>(inst);
    if (!root_3d) {
        inst->queue_free();
        mesh_cache[scene_path] = data;
        return data;
    }

    TypedArray<Node> nodes = root_3d->find_children("*", "MeshInstance3D", true, false);
    if (nodes.size() > 0) {
        Ref<ArrayMesh> combined_mesh;
        combined_mesh.instantiate();

        for (int i = 0; i < nodes.size(); ++i) {
            MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(nodes[i]);
            if (!mi || mi->get_mesh().is_null()) continue;

            Ref<Mesh> original_mesh = mi->get_mesh();
            Transform3D rel_transform = get_relative_transform(root_3d, mi);

            int surface_count = original_mesh->get_surface_count();
            for (int s = 0; s < surface_count; ++s) {
                Array surf_arrays = original_mesh->surface_get_arrays(s);
                if (surf_arrays.size() <= Mesh::ARRAY_VERTEX) continue;

                PackedVector3Array verts = surf_arrays[Mesh::ARRAY_VERTEX];
                for (int v = 0; v < verts.size(); ++v) {
                    verts[v] = rel_transform.xform(verts[v]);
                }
                surf_arrays[Mesh::ARRAY_VERTEX] = verts;

                if (surf_arrays.size() > Mesh::ARRAY_NORMAL && surf_arrays[Mesh::ARRAY_NORMAL].get_type() == Variant::PACKED_VECTOR3_ARRAY) {
                    PackedVector3Array normals = surf_arrays[Mesh::ARRAY_NORMAL];
                    Basis normal_basis = rel_transform.basis.inverse().transposed();
                    for (int n = 0; n < normals.size(); ++n) {
                        normals[n] = normal_basis.xform(normals[n]).normalized();
                    }
                    surf_arrays[Mesh::ARRAY_NORMAL] = normals;
                }

                combined_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, surf_arrays);

                Ref<Material> mat = mi->get_material_override();
                if (mat.is_null()) {
                    mat = mi->get_active_material(s);
                }
                if (mat.is_null()) {
                    mat = original_mesh->surface_get_material(s);
                }

                int new_surface_idx = combined_mesh->get_surface_count() - 1;
                if (mat.is_valid()) {
                    combined_mesh->surface_set_material(new_surface_idx, mat);
                    data.materials.append(mat);
                } else {
                    data.materials.append(Ref<Material>());
                }
            }
        }

        if (combined_mesh->get_surface_count() > 0) {
            data.mesh = combined_mesh;
            data.valid = true;
        }
    }

    inst->queue_free();
    mesh_cache[scene_path] = data;
    return data;
}