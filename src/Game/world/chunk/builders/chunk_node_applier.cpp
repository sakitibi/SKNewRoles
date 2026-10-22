#include "chunk_node_applier.h"
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/base_material3d.hpp>
#include <unordered_map>

using namespace godot;

void ChunkNodeApplier::apply_chunk_data_to_node(Node3D *parent_node, const PureChunkData &built_data) {
    if (!parent_node) return;

    if (built_data.collision_faces.size() > 0) {
        StaticBody3D *static_body = memnew(StaticBody3D);
        static_body->set_name("ChunkStaticBody");

        CollisionShape3D *collision_shape = memnew(CollisionShape3D);
        Ref<ConcavePolygonShape3D> concave_shape;
        concave_shape.instantiate();
        concave_shape->set_faces(built_data.collision_faces);

        collision_shape->set_shape(concave_shape);
        static_body->add_child(collision_shape);

        parent_node->add_child(static_body);
    }

    std::unordered_map<Material*, PureSurfaceData> merged_surfaces;

    for (const auto &block_pair : built_data.block_surfaces) {
        const auto &surfaces = block_pair.second;
        for (const auto &surf : surfaces) {
            if (surf.vertices.empty() || surf.material.is_null()) continue;
            
            Material* mat_ptr = surf.material.ptr();
            PureSurfaceData &target = merged_surfaces[mat_ptr];
            
            if (target.material.is_null()) {
                target.material = surf.material;
            }

            int base_index_offset = target.vertex_count;

            // C++側のバッファに一括で追加
            target.vertices.insert(target.vertices.end(), surf.vertices.begin(), surf.vertices.end());
            target.normals.insert(target.normals.end(), surf.normals.begin(), surf.normals.end());
            target.uvs.insert(target.uvs.end(), surf.uvs.begin(), surf.uvs.end());

            for (int idx : surf.indices) {
                target.indices.push_back(idx + base_index_offset);
            }

            target.vertex_count += surf.vertex_count;
        }
    }

    if (merged_surfaces.empty()) return;

    Ref<ArrayMesh> array_mesh;
    array_mesh.instantiate();

    for (const auto &pair : merged_surfaces) {
        const PureSurfaceData &surf = pair.second;
        if (surf.vertices.empty()) continue;

        PackedVector3Array v_arr;
        v_arr.resize(surf.vertices.size());
        for (size_t i = 0; i < surf.vertices.size(); ++i) {
            v_arr[i] = surf.vertices[i];
        }

        PackedVector3Array n_arr;
        n_arr.resize(surf.normals.size());
        for (size_t i = 0; i < surf.normals.size(); ++i) {
            n_arr[i] = surf.normals[i];
        }

        PackedVector2Array uv_arr;
        uv_arr.resize(surf.uvs.size());
        for (size_t i = 0; i < surf.uvs.size(); ++i) {
            uv_arr[i] = surf.uvs[i];
        }

        PackedInt32Array i_arr;
        i_arr.resize(surf.indices.size());
        for (size_t i = 0; i < surf.indices.size(); ++i) {
            i_arr[i] = surf.indices[i];
        }

        Array surface_arrays;
        surface_arrays.resize(Mesh::ARRAY_MAX);
        surface_arrays[Mesh::ARRAY_VERTEX] = v_arr;
        surface_arrays[Mesh::ARRAY_NORMAL] = n_arr;
        surface_arrays[Mesh::ARRAY_TEX_UV] = uv_arr;
        surface_arrays[Mesh::ARRAY_INDEX] = i_arr;

        int surf_idx = array_mesh->get_surface_count();
        array_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, surface_arrays);

        if (surf.material.is_valid()) {
            Ref<BaseMaterial3D> base_mat = surf.material;
            if (base_mat.is_valid()) {
                base_mat->set_flag(BaseMaterial3D::FLAG_UV1_USE_TRIPLANAR, false);
                base_mat->set_flag(BaseMaterial3D::FLAG_UV1_USE_WORLD_TRIPLANAR, false);
            }
            array_mesh->surface_set_material(surf_idx, surf.material);
        }
    }

    MeshInstance3D *mi = memnew(MeshInstance3D);
    mi->set_mesh(array_mesh);
    parent_node->add_child(mi);
}