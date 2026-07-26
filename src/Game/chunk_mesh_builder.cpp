#include "chunk_mesh_builder.h"
#include <godot_cpp/core/memory.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
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
            if (parent_3d == root) return accumulated_transform;
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
        map["minecraft:dirt"]          = "res://Scenes/Prefabs/Blocks/GrassBlock.tscn";
    }
    return map;
}

void ChunkMeshBuilder::preload_block_meshes() {
    const HashMap<String, String>& block_map = get_block_scene_map();
    for (const auto &E : block_map) {
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
        cache[scene_path] = data;
        return data;
    }

    Node *inst = scene->instantiate();
    Node3D *root_3d = Object::cast_to<Node3D>(inst);
    if (!root_3d) {
        inst->queue_free();
        cache[scene_path] = data;
        return data;
    }

    TypedArray<Node> nodes = root_3d->find_children("*", "MeshInstance3D", true, false);
    if (nodes.size() > 0) {
        MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(nodes[0]);
        if (mi && mi->get_mesh().is_valid()) {
            Ref<Mesh> original_mesh = mi->get_mesh();
            Transform3D rel_transform = get_relative_transform(root_3d, mi);

            Ref<ArrayMesh> transformed_mesh;
            transformed_mesh.instantiate();

            for (int s = 0; s < original_mesh->get_surface_count(); ++s) {
                Array surf_arrays = original_mesh->surface_get_arrays(s);
                if (surf_arrays.size() <= Mesh::ARRAY_VERTEX) continue;

                PackedVector3Array verts = surf_arrays[Mesh::ARRAY_VERTEX];
                for (int v = 0; v < verts.size(); ++v) {
                    verts[v] = rel_transform.xform(verts[v]);
                }
                surf_arrays[Mesh::ARRAY_VERTEX] = verts;

                if (surf_arrays.size() > Mesh::ARRAY_NORMAL) {
                    PackedVector3Array normals = surf_arrays[Mesh::ARRAY_NORMAL];
                    Basis normal_basis = rel_transform.basis.inverse().transposed();
                    for (int n = 0; n < normals.size(); ++n) {
                        normals[n] = normal_basis.xform(normals[n]).normalized();
                    }
                    surf_arrays[Mesh::ARRAY_NORMAL] = normals;
                }

                transformed_mesh->add_surface_from_arrays(Mesh::PRIMITIVE_TRIANGLES, surf_arrays);

                Ref<Material> mat = mi->get_material_override();
                if (mat.is_null()) {
                    mat = mi->get_active_material(s);
                }
                if (mat.is_null()) {
                    mat = original_mesh->surface_get_material(s);
                }

                if (mat.is_valid()) {
                    transformed_mesh->surface_set_material(s, mat);
                    data.materials.append(mat);
                }
            }

            data.mesh = transformed_mesh;
            data.valid = true;
        }
    }

    inst->queue_free();
    cache[scene_path] = data;
    return data;
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (palette_size <= 1) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = (y * 16 + z) * 16 + x;
    int entries_per_long = 64 / bits_per_entry;

    int long_index = block_index / entries_per_long;
    int bit_offset = (block_index % entries_per_long) * bits_per_entry;

    if (long_index >= data.size()) return 0;

    uint64_t long_val = static_cast<uint64_t>(data[long_index]);
    uint64_t mask = (1ULL << bits_per_entry) - 1ULL;

    return static_cast<int>((long_val >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(const Dictionary &chunk_data, int min_section_y, int max_section_y) {
    HashMap<String, Vector<Vector3>> result;

    if (!chunk_data.has("sections")) return result;

    Array sections = chunk_data["sections"];
    for (int i = 0; i < sections.size(); ++i) {
        Dictionary sec = sections[i];
        if (!sec.has("Y") || !sec.has("block_states")) continue;

        int sec_y = sec["Y"];
        if (sec_y < min_section_y || sec_y > max_section_y) continue;

        Dictionary block_states = sec["block_states"];
        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        if (palette.size() == 0) continue;

        if (!block_states.has("data")) {
            Dictionary b = palette[0];
            String name = b.get("Name", "");
            if (name != "minecraft:air") {
                Vector<Vector3> &vec = result[name];
                for (int y = 0; y < 16; ++y) {
                    for (int z = 0; z < 16; ++z) {
                        for (int x = 0; x < 16; ++x) {
                            vec.append(Vector3(x, sec_y * 16 + y, z));
                        }
                    }
                }
            }
            continue;
        }

        PackedInt64Array data_array = block_states["data"];
        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_idx = get_palette_index(data_array, palette.size(), x, y, z);
                    if (p_idx >= 0 && p_idx < palette.size()) {
                        Dictionary b = palette[p_idx];
                        String name = b.get("Name", "");
                        if (name != "minecraft:air") {
                            result[name].append(Vector3(x, sec_y * 16 + y, z));
                        }
                    }
                }
            }
        }
    }

    return result;
}

static void create_merged_box_collisions(
    StaticBody3D *static_body,
    const HashSet<Vector3i> &occupied_blocks,
    int section_y
) {
    int start_y = section_y * 16;
    bool grid[16][16][16] = {};

    for (int y = 0; y < 16; ++y) {
        int world_y = start_y + y;
        for (int z = 0; z < 16; ++z) {
            for (int x = 0; x < 16; ++x) {
                Vector3i g_pos(x, world_y, z);

                if (!occupied_blocks.has(g_pos)) continue;

                bool is_surrounded = 
                    occupied_blocks.has(g_pos + Vector3i(1, 0, 0)) &&
                    occupied_blocks.has(g_pos + Vector3i(-1, 0, 0)) &&
                    occupied_blocks.has(g_pos + Vector3i(0, 1, 0)) &&
                    occupied_blocks.has(g_pos + Vector3i(0, -1, 0)) &&
                    occupied_blocks.has(g_pos + Vector3i(0, 0, 1)) &&
                    occupied_blocks.has(g_pos + Vector3i(0, 0, -1));

                if (!is_surrounded) {
                    grid[y][z][x] = true;
                }
            }
        }
    }

    for (int y = 0; y < 16; ++y) {
        int world_y = start_y + y;
        bool visited[16][16] = {};

        for (int z = 0; z < 16; ++z) {
            for (int x = 0; x < 16; ++x) {
                if (!grid[y][z][x] || visited[z][x]) continue;

                int width_x = 1;
                while (x + width_x < 16 && grid[y][z][x + width_x] && !visited[z][x + width_x]) {
                    width_x++;
                }

                int depth_z = 1;
                while (z + depth_z < 16) {
                    bool can_extend = true;
                    for (int k = 0; k < width_x; ++k) {
                        if (!grid[y][z + depth_z][x + k] || visited[z + depth_z][x + k]) {
                            can_extend = false;
                            break;
                        }
                    }
                    if (!can_extend) break;
                    depth_z++;
                }

                for (int dz = 0; dz < depth_z; dz++) {
                    for (int dx = 0; dx < width_x; dx++) {
                        visited[z + dz][x + dx] = true;
                    }
                }

                float size_x = (float)width_x;
                float size_y = 1.0f;
                float size_z = (float)depth_z;

                float center_x = x + (size_x - 1.0f) * 0.5f;
                float center_y = (float)world_y;
                float center_z = z + (size_z - 1.0f) * 0.5f;

                Ref<BoxShape3D> box_shape;
                box_shape.instantiate();
                box_shape->set_size(Vector3(size_x, size_y, size_z));

                CollisionShape3D *col_shape = memnew(CollisionShape3D);
                col_shape->set_shape(box_shape);
                col_shape->set_position(Vector3(center_x, center_y, center_z));

                static_body->add_child(col_shape);
            }
        }
    }
}

void ChunkMeshBuilder::build_from_positions(Node3D *parent_node, const HashMap<String, Vector<Vector3>> &categorized_positions) {
    const HashMap<String, String> &block_map = get_block_scene_map();

    HashSet<Vector3i> occupied_blocks;
    HashSet<int> active_section_ys;

    for (const auto &E : categorized_positions) {
        for (int i = 0; i < E.value.size(); ++i) {
            Vector3 pos = E.value[i];
            Vector3i grid_pos(
                static_cast<int>(std::floor(pos.x + 0.5f)),
                static_cast<int>(std::floor(pos.y + 0.5f)),
                static_cast<int>(std::floor(pos.z + 0.5f))
            );
            occupied_blocks.insert(grid_pos);

            int sec_y = static_cast<int>(std::floor((float)grid_pos.y / 16.0f));
            active_section_ys.insert(sec_y);
        }
    }

    // 描画用 MultiMeshInstance3D の生成
    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!block_map.has(block_name) || positions.is_empty()) continue;

        String scene_path = block_map[block_name];
        BlockMeshData mesh_data = get_block_mesh_data(scene_path);
        if (!mesh_data.valid || mesh_data.mesh.is_null()) continue;

        MultiMeshInstance3D *mmi = memnew(MultiMeshInstance3D);
        Ref<MultiMesh> mm;
        mm.instantiate();
        mm->set_transform_format(MultiMesh::TRANSFORM_3D);
        mm->set_mesh(mesh_data.mesh);
        mm->set_instance_count(positions.size());

        // MultiMeshInstance3D へのマテリアル適用
        if (mesh_data.materials.size() > 0 && mesh_data.materials[0].is_valid()) {
            mmi->set_material_override(mesh_data.materials[0]);
        }

        for (int i = 0; i < positions.size(); ++i) {
            Transform3D t;
            t.origin = positions[i];
            mm->set_instance_transform(i, t);
        }

        mmi->set_multimesh(mm);
        parent_node->add_child(mmi);
    }

    // 結合コリジョンの生成
    StaticBody3D *static_body = memnew(StaticBody3D);
    static_body->set_collision_layer(1);
    static_body->set_collision_mask(1);

    for (const int sec_y : active_section_ys) {
        create_merged_box_collisions(static_body, occupied_blocks, sec_y);
    }

    if (static_body->get_child_count() > 0) {
        parent_node->add_child(static_body);
    } else {
        memdelete(static_body);
    }
}