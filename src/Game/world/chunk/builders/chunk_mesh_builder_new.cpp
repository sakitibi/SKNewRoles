#include "chunk_mesh_builder_new.h"
#include "../chunk_collision_builder.h"
#include "../../cube_mesh_utils.h"
#include "../../../../Blocks/block_registry.h"
#include "../../../../Blocks/block_mesh_cache.h"

#include <godot_cpp/classes/base_material3d.hpp>
#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>

using namespace godot;

static inline Vector3i to_grid_pos(const Vector3 &v) {
    return Vector3i(
        static_cast<int>(std::round(v.x)),
        static_cast<int>(std::round(v.y)),
        static_cast<int>(std::round(v.z))
    );
}

static inline bool is_dirt_path_id(const String &block_id) {
    return block_id == "minecraft:dirt_path" ||
        block_id.contains("dirt_path") ||
        block_id.contains("DirtPath");
}

static Ref<Material> resolve_face_material(const BlockMeshData &mesh_data, int face_index) {
    if (!mesh_data.valid || mesh_data.materials.is_empty()) {
        return Ref<Material>();
    }

    int mat_count = mesh_data.materials.size();

    if (mat_count == 1) {
        return mesh_data.materials[0];
    }

    if (face_index >= 0 && face_index < mat_count && mesh_data.materials[face_index].is_valid()) {
        return mesh_data.materials[face_index];
    }

    if (mesh_data.materials[0].is_valid()) {
        return mesh_data.materials[0];
    }

    return Ref<Material>();
}

BuiltChunkDataNew ChunkMeshBuilderNew::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions,
    bool p_is_initial_load
) {
    BuiltChunkDataNew result;

    HashSet<Vector3i> occupied_blocks;
    HashSet<Vector3i> dirt_path_blocks;

    for (const auto &E : categorized_positions) {
        bool is_dirt_path = is_dirt_path_id(E.key);
        for (const Vector3 &pos : E.value) {
            Vector3i grid_pos = to_grid_pos(pos);
            occupied_blocks.insert(grid_pos);
            if (is_dirt_path) {
                dirt_path_blocks.insert(grid_pos);
            }
        }
    }

    const HashMap<String, String> &registry_map = BlockRegistry::get_block_scene_map();

    for (const auto &E : categorized_positions) {
        String block_id = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!registry_map.has(block_id)) continue;
        String scene_path = registry_map[block_id];

        float height = is_dirt_path_id(block_id) ? 0.938f : 1.0f;

        Vector<CubeFaceData> faces = CubeMeshUtils::get_cube_faces(height);
        BlockMeshData mesh_data = BlockMeshCache::get_block_mesh_data(scene_path);

        HashMap<Ref<Material>, SurfaceMeshDataNew> surface_map;

        for (const Vector3 &pos : positions) {
            Vector3i grid_pos = to_grid_pos(pos);

            for (int f = 0; f < 6; ++f) {
                const CubeFaceData &face = faces[f];
                Vector3i neighbor_pos = grid_pos + face.dir;

                if (occupied_blocks.has(neighbor_pos) && !dirt_path_blocks.has(neighbor_pos)) {
                    continue;
                }

                Ref<Material> face_mat = resolve_face_material(mesh_data, f);

                SurfaceMeshDataNew &surf = surface_map[face_mat];
                surf.material = face_mat;

                for (int v = 0; v < 4; ++v) {
                    surf.vertices.append(pos + face.vertices[v]);
                    surf.normals.append(face.normal);
                    surf.uvs.append(face.uvs[v]);
                }

                surf.indices.append(surf.vertex_count + 0);
                surf.indices.append(surf.vertex_count + 1);
                surf.indices.append(surf.vertex_count + 2);
                surf.indices.append(surf.vertex_count + 0);
                surf.indices.append(surf.vertex_count + 2);
                surf.indices.append(surf.vertex_count + 3);

                surf.vertex_count += 4;
            }
        }

        if (surface_map.is_empty()) continue;

        Ref<ArrayMesh> array_mesh;
        array_mesh.instantiate();

        for (const auto &S : surface_map) {
            const SurfaceMeshDataNew &surf = S.value;
            if (surf.vertices.size() == 0) continue;

            Array surface_arrays;
            surface_arrays.resize(Mesh::ARRAY_MAX);
            surface_arrays[Mesh::ARRAY_VERTEX] = surf.vertices;
            surface_arrays[Mesh::ARRAY_NORMAL] = surf.normals;
            surface_arrays[Mesh::ARRAY_TEX_UV] = surf.uvs;
            surface_arrays[Mesh::ARRAY_INDEX] = surf.indices;

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

        result.meshes[block_id] = array_mesh;
    }

    result.collision_faces = ChunkCollisionBuilder::build_collision_faces(categorized_positions);
    return result;
}