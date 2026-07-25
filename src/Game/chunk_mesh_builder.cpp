#include "chunk_mesh_builder.h"
#include <godot_cpp/core/memory.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <cmath>

using namespace godot;

const HashMap<String, String>& ChunkMeshBuilder::get_block_scene_map() {
    static HashMap<String, String> map;
    if (map.is_empty()) {
        map["minecraft:grass_block"]   = "res://Scenes/Prefabs/Blocks/GrassBlock.tscn";
        map["minecraft:stone"]         = "res://Scenes/Prefabs/Blocks/Stone.tscn";
        map["minecraft:stone_bricks"]  = "res://Scenes/Prefabs/Blocks/StoneBricks.tscn";
        map["minecraft:gold_block"]    = "res://Scenes/Prefabs/Blocks/GoldBlock.tscn";
        map["minecraft:dirt"]          = "res://Scenes/Prefabs/Blocks/GrassBlock.tscn";
    }
    return map;
}

void ChunkMeshBuilder::preload_block_meshes() {
    UtilityFunctions::print("[ChunkMeshBuilder] Preloading block meshes...");
    const HashMap<String, String> &map = get_block_scene_map();
    for (const auto &E : map) {
        get_block_mesh_data(E.value);
    }
}

BlockMeshData ChunkMeshBuilder::get_block_mesh_data(const String &scene_path) {
    static HashMap<String, BlockMeshData> cache;
    if (cache.has(scene_path)) {
        return cache[scene_path];
    }

    UtilityFunctions::print("[ChunkMeshBuilder] Loading scene for mesh cache: ", scene_path);

    BlockMeshData res;
    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    if (scene.is_null()) {
        UtilityFunctions::printerr("[ChunkMeshBuilder] ERROR: Failed to load scene: ", scene_path);
        cache[scene_path] = res;
        return res;
    }

    Node *inst = scene->instantiate();
    if (!inst) {
        UtilityFunctions::printerr("[ChunkMeshBuilder] ERROR: Failed to instantiate scene: ", scene_path);
        cache[scene_path] = res;
        return res;
    }

    TypedArray<Node> children = inst->find_children("*", "MeshInstance3D", true, false);
    MeshInstance3D *root_mi = Object::cast_to<MeshInstance3D>(inst);
    if (root_mi) {
        children.push_back(root_mi);
    }

    UtilityFunctions::print("[ChunkMeshBuilder] Found ", children.size(), " MeshInstance3D nodes in ", scene_path);

    if (children.is_empty()) {
        UtilityFunctions::printerr("[ChunkMeshBuilder] ERROR: No MeshInstance3D found in ", scene_path);
        memdelete(inst);
        cache[scene_path] = res;
        return res;
    }

    Ref<ArrayMesh> combined_mesh;
    combined_mesh.instantiate();

    Node3D *root_3d = Object::cast_to<Node3D>(inst);

    int total_vertices_added = 0;

    for (int c = 0; c < children.size(); ++c) {
        MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(children[c]);
        if (!mi || mi->get_mesh().is_null()) {
            UtilityFunctions::print("[ChunkMeshBuilder] Node ", c, " has no mesh. Skipping.");
            continue;
        }

        Ref<Mesh> src_mesh = mi->get_mesh();

        Transform3D xform;
        if (root_3d) {
            xform = root_3d->get_global_transform().affine_inverse() * mi->get_global_transform();
        } else {
            xform = mi->get_transform();
        }

        for (int s = 0; s < src_mesh->get_surface_count(); ++s) {
            Array surf_arrays = src_mesh->surface_get_arrays(s);
            if (surf_arrays.size() <= Mesh::ARRAY_VERTEX) continue;

            PackedVector3Array src_verts = surf_arrays[Mesh::ARRAY_VERTEX];
            if (src_verts.is_empty()) continue;

            PackedVector3Array dst_verts;
            dst_verts.resize(src_verts.size());
            for (int v = 0; v < src_verts.size(); ++v) {
                dst_verts.set(v, xform.xform(src_verts[v]));
            }
            surf_arrays[Mesh::ARRAY_VERTEX] = dst_verts;

            if (surf_arrays.size() > Mesh::ARRAY_NORMAL) {
                PackedVector3Array src_normals = surf_arrays[Mesh::ARRAY_NORMAL];
                if (!src_normals.is_empty()) {
                    Basis normal_basis = xform.basis.inverse().transposed();
                    PackedVector3Array dst_normals;
                    dst_normals.resize(src_normals.size());
                    for (int v = 0; v < src_normals.size(); ++v) {
                        dst_normals.set(v, normal_basis.xform(src_normals[v]).normalized());
                    }
                    surf_arrays[Mesh::ARRAY_NORMAL] = dst_normals;
                }
            }

            combined_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, surf_arrays);
            total_vertices_added += dst_verts.size();

            Ref<Material> mat = mi->get_surface_override_material(s);
            if (mat.is_null()) {
                mat = src_mesh->surface_get_material(s);
            }
            res.materials.push_back(mat);
        }
    }

    memdelete(inst);

    if (combined_mesh->get_surface_count() > 0) {
        res.mesh = combined_mesh;
        res.valid = true;
        UtilityFunctions::print("[ChunkMeshBuilder] Successfully built combined mesh for ", scene_path, 
                                " (Surfaces: ", combined_mesh->get_surface_count(), 
                                ", Vertices: ", total_vertices_added, ")");
    } else {
        UtilityFunctions::printerr("[ChunkMeshBuilder] ERROR: Combined mesh has 0 surfaces for ", scene_path);
    }

    cache[scene_path] = res;
    return res;
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (data.is_empty() || palette_size <= 0) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = y * 256 + z * 16 + x;
    int entries_per_long = 64 / bits_per_entry;
    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index < 0 || long_index >= data.size()) return 0;

    uint64_t long_val = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1ULL;
    return static_cast<int>((long_val >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::extract_block_positions(const Array &sections) {
    HashMap<String, Vector<Vector3>> categorized_positions;
    const HashMap<String, String> &block_map = get_block_scene_map();

    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int sec_y = section["Y"];
        Dictionary block_states = section["block_states"];

        if (!block_states.has("palette")) continue;
        Array palette = block_states["palette"];

        PackedInt64Array data;
        if (block_states.has("data")) {
            data = block_states["data"];
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = 0;
                    if (palette.size() > 1) {
                        p_idx = get_palette_index(data, palette.size(), x, y, z);
                    }

                    if (p_idx >= 0 && p_idx < palette.size()) {
                        Dictionary block = palette[p_idx];
                        String block_name = block.get("Name", "minecraft:air");

                        if (block_map.has(block_name)) {
                            Vector3 pos(x, sec_y * 16 + y, z);
                            categorized_positions[block_name].push_back(pos);
                        }
                    }
                }
            }
        }
    }

    return categorized_positions;
}

void ChunkMeshBuilder::build_from_positions(Node3D *parent_node, const HashMap<String, Vector<Vector3>> &categorized_positions) {
    const HashMap<String, String> &block_map = get_block_scene_map();
    PackedVector3Array collision_faces;

    UtilityFunctions::print("[ChunkMeshBuilder] Starting build_from_positions for node: ", parent_node->get_name());

    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!block_map.has(block_name) || positions.is_empty()) continue;

        String scene_path = block_map[block_name];
        BlockMeshData mesh_data = get_block_mesh_data(scene_path);

        if (!mesh_data.valid || mesh_data.mesh.is_null()) {
            UtilityFunctions::printerr("[ChunkMeshBuilder] Invalid mesh data for block: ", block_name);
            continue;
        }

        UtilityFunctions::print("[ChunkMeshBuilder] Generating MultiMesh for block '", block_name, 
                                "' with ", positions.size(), " instances.");

        MultiMeshInstance3D *mmi = memnew(MultiMeshInstance3D);
        Ref<MultiMesh> mm;
        mm.instantiate();

        mm->set_transform_format(MultiMesh::TRANSFORM_3D);
        mm->set_mesh(mesh_data.mesh);
        mm->set_instance_count(positions.size());

        AABB total_aabb;
        bool first_aabb = true;

        for (int i = 0; i < positions.size(); ++i) {
            Transform3D t;
            t.basis = Basis();
            t.origin = positions[i];
            mm->set_instance_transform(i, t);

            AABB box = mesh_data.mesh->get_aabb();
            box.position += positions[i];
            if (first_aabb) {
                total_aabb = box;
                first_aabb = false;
            } else {
                total_aabb = total_aabb.merge(box);
            }
        }

        mmi->set_multimesh(mm);

        if (!first_aabb) {
            mmi->set_custom_aabb(total_aabb);
            UtilityFunctions::print("  -> MultiMesh AABB Position: ", total_aabb.position, 
                                    ", Size: ", total_aabb.size);
        }

        for (int s = 0; s < mesh_data.materials.size(); ++s) {
            if (!mesh_data.materials.is_empty() && mesh_data.materials[0].is_valid()) {
                mmi->set_material_override(mesh_data.materials[0]);
            }
        }

        parent_node->add_child(mmi);

        // 当たり判定頂点抽出
        for (int s = 0; s < mesh_data.mesh->get_surface_count(); ++s) {
            Array surf_arrays = mesh_data.mesh->surface_get_arrays(s);
            if (surf_arrays.size() <= Mesh::ARRAY_VERTEX) continue;

            PackedVector3Array verts = surf_arrays[Mesh::ARRAY_VERTEX];
            PackedInt32Array indices = surf_arrays[Mesh::ARRAY_INDEX];

            for (int i = 0; i < positions.size(); ++i) {
                Vector3 block_pos = positions[i];

                if (indices.size() > 0) {
                    for (int idx = 0; idx < indices.size(); ++idx) {
                        collision_faces.append(verts[indices[idx]] + block_pos);
                    }
                } else {
                    for (int v = 0; v < verts.size(); ++v) {
                        collision_faces.append(verts[v] + block_pos);
                    }
                }
            }
        }
    }

    if (collision_faces.size() > 0) {
        UtilityFunctions::print("[ChunkMeshBuilder] Creating Collision Shape with ", collision_faces.size(), " faces.");
        StaticBody3D *static_body = memnew(StaticBody3D);
        static_body->set_collision_layer(1);
        static_body->set_collision_mask(1);

        CollisionShape3D *col_shape = memnew(CollisionShape3D);
        Ref<ConcavePolygonShape3D> concave_shape;
        concave_shape.instantiate();
        concave_shape->set_faces(collision_faces);

        col_shape->set_shape(concave_shape);
        static_body->add_child(col_shape);

        parent_node->add_child(static_body);
    }
}