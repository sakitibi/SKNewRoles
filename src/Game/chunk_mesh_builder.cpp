#include "chunk_mesh_builder.h"
#include <godot_cpp/core/memory.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <cmath>

using namespace godot;

static Transform3D get_relative_transform(Node3D *root, Node3D *target) {
    if (!root || !target) return Transform3D();
    if (root == target) return Transform3D();

    Transform3D accumulated_transform = target->get_transform();
    Node *parent = target->get_parent();

    while (parent != nullptr) {
        Node3D *parent_3d = Object::cast_to<Node3D>(parent);
        if (parent_3d) {
            if (parent_3d == root) {
                return accumulated_transform;
            }
            accumulated_transform = parent_3d->get_transform() * accumulated_transform;
        }
        parent = parent->get_parent();
    }

    return accumulated_transform;
}

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

    BlockMeshData data;
    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    if (scene.is_null()) {
        UtilityFunctions::printerr("[ChunkMeshBuilder] Failed to load scene: ", scene_path);
        return data;
    }

    Node *inst = scene->instantiate();
    Node3D *root_3d = Object::cast_to<Node3D>(inst);
    if (!root_3d) {
        UtilityFunctions::printerr("[ChunkMeshBuilder] Root node of scene is not Node3D: ", scene_path);
        if (inst) memdelete(inst);
        return data;
    }

    List<Node *> nodes;
    nodes.push_back(root_3d);

    Vector<MeshInstance3D *> mesh_instances;
    while (!nodes.is_empty()) {
        Node *curr = nodes.front()->get();
        nodes.pop_front();

        MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(curr);
        if (mi && mi->get_mesh().is_valid()) {
            mesh_instances.append(mi);
        }

        for (int i = 0; i < curr->get_child_count(); ++i) {
            nodes.push_back(curr->get_child(i));
        }
    }

    Ref<ArrayMesh> combined_mesh;
    combined_mesh.instantiate();

    for (int i = 0; i < mesh_instances.size(); ++i) {
        MeshInstance3D *mi = mesh_instances[i];
        Ref<Mesh> mesh = mi->get_mesh();

        Transform3D xform = get_relative_transform(root_3d, mi);

        for (int s = 0; s < mesh->get_surface_count(); ++s) {
            Array surf_arrays = mesh->surface_get_arrays(s);
            if (surf_arrays.size() <= Mesh::ARRAY_VERTEX) continue;

            PackedVector3Array verts = surf_arrays[Mesh::ARRAY_VERTEX];
            PackedVector3Array new_verts;
            new_verts.resize(verts.size());

            for (int v = 0; v < verts.size(); ++v) {
                new_verts.set(v, xform.xform(verts[v]));
            }
            surf_arrays[Mesh::ARRAY_VERTEX] = new_verts;

            if (surf_arrays.size() > Mesh::ARRAY_NORMAL) {
                PackedVector3Array normals = surf_arrays[Mesh::ARRAY_NORMAL];
                if (normals.size() > 0) {
                    PackedVector3Array new_normals;
                    new_normals.resize(normals.size());
                    Basis normal_basis = xform.basis.inverse().transposed();
                    for (int n = 0; n < normals.size(); ++n) {
                        new_normals.set(n, normal_basis.xform(normals[n]).normalized());
                    }
                    surf_arrays[Mesh::ARRAY_NORMAL] = new_normals;
                }
            }

            Ref<Material> mat = mi->get_surface_override_material(s);
            if (mat.is_null()) mat = mi->get_material_override();
            if (mat.is_null()) mat = mesh->surface_get_material(s);

            if (mat.is_valid()) {
                Ref<StandardMaterial3D> std_mat = mat->duplicate();
                if (std_mat.is_valid()) {
                    std_mat->set_flag(StandardMaterial3D::FLAG_UV1_USE_TRIPLANAR, false);
                    std_mat->set_flag(StandardMaterial3D::FLAG_UV2_USE_TRIPLANAR, false);
                    mat = std_mat;
                }
            }

            int new_surface_index = combined_mesh->get_surface_count();
            combined_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, surf_arrays);
            combined_mesh->surface_set_material(new_surface_index, mat);
            
            data.materials.append(mat);
        }
    }

    memdelete(root_3d);

    if (combined_mesh->get_surface_count() > 0) {
        data.mesh = combined_mesh;
        data.valid = true;
        cache[scene_path] = data;
    }

    return data;
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (data.is_empty()) return 0;

    int bits_per_entry = std::max(4, (int)std::ceil(std::log2(palette_size)));
    int entries_per_long = 64 / bits_per_entry;
    int block_index = (y * 16 + z) * 16 + x;

    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index >= data.size()) return 0;

    uint64_t raw_long = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1;
    return static_cast<int>((raw_long >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(const Dictionary &chunk_data) {
    HashMap<String, Vector<Vector3>> categorized_positions;

    if (!chunk_data.has("sections")) return categorized_positions;

    Array sections = chunk_data["sections"];
    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("Y") || !section.has("block_states")) continue;

        int section_y = section["Y"];
        Dictionary block_states = section["block_states"];

        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        PackedInt64Array data;
        if (block_states.has("data")) {
            data = block_states["data"];
        }

        Vector<String> palette_names;
        for (int p = 0; p < palette.size(); ++p) {
            Dictionary state = palette[p];
            String name = state.has("Name") ? String(state["Name"]) : "minecraft:air";
            palette_names.append(name);
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = 0;
                    if (data.size() > 0) {
                        p_idx = get_palette_index(data, palette.size(), x, y, z);
                    }

                    if (p_idx >= 0 && p_idx < palette_names.size()) {
                        String b_name = palette_names[p_idx];
                        if (b_name != "minecraft:air" && b_name != "minecraft:cave_air" && b_name != "minecraft:void_air") {
                            Vector3 world_pos(x - 0.5f, (section_y * 16) + y - 0.5f, z - 0.5f);
                            categorized_positions[b_name].append(world_pos);
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

    HashSet<Vector3i> occupied_blocks;
    for (const auto &E : categorized_positions) {
        for (int i = 0; i < E.value.size(); ++i) {
            Vector3 pos = E.value[i];
            Vector3i grid_pos(
                static_cast<int>(std::round(pos.x + 0.5f)),
                static_cast<int>(std::round(pos.y + 0.5f)),
                static_cast<int>(std::round(pos.z + 0.5f))
            );
            occupied_blocks.insert(grid_pos);
        }
    }

    StaticBody3D *static_body = nullptr;
    Ref<BoxShape3D> shared_box_shape;

    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!block_map.has(block_name) || positions.is_empty()) continue;

        String scene_path = block_map[block_name];
        BlockMeshData mesh_data = get_block_mesh_data(scene_path);
        if (!mesh_data.valid || mesh_data.mesh.is_null()) continue;

        // 描画用のMultiMesh
        MultiMeshInstance3D *mmi = memnew(MultiMeshInstance3D);
        Ref<MultiMesh> mm;
        mm.instantiate();

        mm->set_transform_format(MultiMesh::TRANSFORM_3D);
        mm->set_mesh(mesh_data.mesh);
        mm->set_instance_count(positions.size());

        for (int i = 0; i < positions.size(); ++i) {
            Transform3D t;
            t.origin = positions[i];
            mm->set_instance_transform(i, t);
        }

        mmi->set_multimesh(mm);
        parent_node->add_child(mmi);

        if (shared_box_shape.is_null()) {
            shared_box_shape.instantiate();
            shared_box_shape->set_size(Vector3(1.0f, 1.0f, 1.0f));
        }

        if (!static_body) {
            static_body = memnew(StaticBody3D);
            static_body->set_collision_layer(1);
            static_body->set_collision_mask(1);
        }

        for (int i = 0; i < positions.size(); ++i) {
            Vector3 block_pos = positions[i];
            Vector3i grid_pos(
                static_cast<int>(std::round(block_pos.x + 0.5f)),
                static_cast<int>(std::round(block_pos.y + 0.5f)),
                static_cast<int>(std::round(block_pos.z + 0.5f))
            );

            // 6方向が完全に囲まれているブロックは判定を作らない
            bool is_surrounded = 
                occupied_blocks.has(grid_pos + Vector3i(1, 0, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(-1, 0, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, 1, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, -1, 0)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, 0, 1)) &&
                occupied_blocks.has(grid_pos + Vector3i(0, 0, -1));

            if (is_surrounded) continue;

            CollisionShape3D *col_shape = memnew(CollisionShape3D);
            col_shape->set_shape(shared_box_shape);
            col_shape->set_position(block_pos);
            static_body->add_child(col_shape);
        }
    }

    if (static_body) {
        if (static_body->get_child_count() > 0) {
            parent_node->add_child(static_body);
        } else {
            memdelete(static_body);
        }
    }
}