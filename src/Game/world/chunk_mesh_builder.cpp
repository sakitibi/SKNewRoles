#include "chunk_mesh_builder.h"
#include "chunk_collision_builder.h"
#include "../../Blocks/block_registry.h"
#include "../../Blocks/block_mesh_cache.h"

#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/base_material3d.hpp>
#include <godot_cpp/classes/standard_material3d.hpp>
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

ChunkMeshBuilder::ChunkMeshBuilder() {}
ChunkMeshBuilder::~ChunkMeshBuilder() {}

void ChunkMeshBuilder::_bind_methods() {}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (palette_size <= 1) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = y * 256 + z * 16 + x;
    int entries_per_long = 64 / bits_per_entry;
    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index < 0 || long_index >= data.size()) return 0;

    uint64_t raw_long = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1;
    return static_cast<int>((raw_long >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(
    const Dictionary &chunk_data,
    int min_section_y,
    int max_section_y
) {
    HashMap<String, Vector<Vector3>> categorized_positions;
    if (!chunk_data.has("sections")) return categorized_positions;

    Array sections = chunk_data["sections"];

    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int section_y = section["Y"];
        if (section_y < min_section_y || section_y > max_section_y) continue;

        Dictionary block_states = section["block_states"];
        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        PackedInt64Array data_array;
        if (block_states.has("data")) {
            data_array = block_states["data"];
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = 0;
                    if (!data_array.is_empty()) {
                        p_idx = get_palette_index(data_array, palette.size(), x, y, z);
                    }

                    if (p_idx >= 0 && p_idx < palette.size()) {
                        Dictionary b_entry = palette[p_idx];
                        String block_name = b_entry.get("Name", "minecraft:air");

                        if (block_name != "minecraft:air" && BlockRegistry::has_block(block_name)) {
                            Vector3 pos(static_cast<float>(x), static_cast<float>(section_y * 16 + y), static_cast<float>(z));
                            categorized_positions[block_name].append(pos);
                        }
                    }
                }
            }
        }
    }

    return categorized_positions;
}

const CubeFaceData ChunkMeshBuilder::CUBE_FACES[6] = {
    // 0: Top (+Y)
    { Vector3i(0, 1, 0), Vector3(0, 1, 0),
      { Vector3(0, 1, 0), Vector3(1, 1, 0), Vector3(1, 1, 1), Vector3(0, 1, 1) },
      { Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1) } },

    // 1: Bottom (-Y)
    { Vector3i(0, -1, 0), Vector3(0, -1, 0),
      { Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, 0) },
      { Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1) } },

    // 2: Front (+Z)
    { Vector3i(0, 0, 1), Vector3(0, 0, 1),
      { Vector3(0, 1, 1), Vector3(1, 1, 1), Vector3(1, 0, 1), Vector3(0, 0, 1) },
      { Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1) } },

    // 3: Back (-Z)
    { Vector3i(0, 0, -1), Vector3(0, 0, -1),
      { Vector3(1, 1, 0), Vector3(0, 1, 0), Vector3(0, 0, 0), Vector3(1, 0, 0) },
      { Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1) } },

    // 4: Right (+X)
    { Vector3i(1, 0, 0), Vector3(1, 0, 0),
      { Vector3(1, 1, 1), Vector3(1, 1, 0), Vector3(1, 0, 0), Vector3(1, 0, 1) },
      { Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1) } },

    // 5: Left (-X)
    { Vector3i(-1, 0, 0), Vector3(-1, 0, 0),
      { Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 0, 1), Vector3(0, 0, 0) },
      { Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1) } }
};

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

BuiltChunkData ChunkMeshBuilder::build_chunk_data_async(
    const HashMap<String, Vector<Vector3>> &categorized_positions,
    bool p_is_initial_load
) {
    BuiltChunkData result;

    HashSet<Vector3i> occupied_blocks;
    for (const auto &E : categorized_positions) {
        for (const Vector3 &pos : E.value) {
            occupied_blocks.insert(to_grid_pos(pos));
        }
    }

    const HashMap<String, String> &registry_map = BlockRegistry::get_block_scene_map();

    for (const auto &E : categorized_positions) {
        String block_id = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!registry_map.has(block_id)) continue;
        String scene_path = registry_map[block_id];

        BlockMeshData mesh_data = BlockMeshCache::get_block_mesh_data(scene_path);

        HashMap<Ref<Material>, SurfaceMeshData> surface_map;

        for (const Vector3 &pos : positions) {
            Vector3i grid_pos = to_grid_pos(pos);

            for (int f = 0; f < 6; ++f) {
                Vector3i neighbor_pos = grid_pos + CUBE_FACES[f].dir;

                if (occupied_blocks.has(neighbor_pos)) continue;

                Ref<Material> face_mat = resolve_face_material(mesh_data, f);

                SurfaceMeshData &surf = surface_map[face_mat];
                surf.material = face_mat;

                bool has_cached_verts = (mesh_data.valid && 
                                         mesh_data.face_vertices.size() == 6 && 
                                         mesh_data.face_vertices[f].size() >= 4);

                const PackedVector3Array &cached_f_verts = has_cached_verts ? mesh_data.face_vertices[f] : PackedVector3Array();

                for (int v = 0; v < 4; ++v) {
                    Vector3 v_offset = has_cached_verts ? cached_f_verts[v] : CUBE_FACES[f].vertices[v];

                    surf.vertices.append(pos + v_offset);
                    surf.normals.append(CUBE_FACES[f].normal);
                    surf.uvs.append(CUBE_FACES[f].uvs[v]);
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
            const SurfaceMeshData &surf = S.value;
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
        UtilityFunctions::print("[ChunkMeshBuilder] Built mesh for block: ", block_id, " | Surfaces: ", array_mesh->get_surface_count());
    }

    result.collision_faces = ChunkCollisionBuilder::build_collision_faces(categorized_positions);

    return result;
}

void ChunkMeshBuilder::apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkData &built_data) {
    if (!parent_node) return;

    for (const auto &E : built_data.meshes) {
        MeshInstance3D *mi = memnew(MeshInstance3D);
        mi->set_mesh(E.value);
        parent_node->add_child(mi);
    }

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
}