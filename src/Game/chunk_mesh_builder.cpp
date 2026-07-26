#include "chunk_mesh_builder.h"
#include <godot_cpp/core/memory.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/box_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
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
        map["minecraft:dirt"]          = "res://Scenes/Prefabs/Blocks/Dirt.tscn";
        map["minecraft:cobblestone"]   = "res://Scenes/Prefabs/Blocks/Cobblestone.tscn";
    }
    return map;
}

void ChunkMeshBuilder::preload_block_meshes() {
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
    cache[scene_path] = data;
    return data;
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (data.is_empty() || palette_size <= 1) return 0;

    int bits_per_entry = 4;
    while ((1 << bits_per_entry) < palette_size) {
        bits_per_entry++;
    }

    int block_index = y * 256 + z * 16 + x;
    int entries_per_long = 64 / bits_per_entry;
    int long_index = block_index / entries_per_long;

    if (long_index >= data.size()) return 0;

    int bit_offset = (block_index % entries_per_long) * bits_per_entry;
    int64_t mask = (1LL << bits_per_entry) - 1;
    int64_t val = data[long_index];

    return static_cast<int>((val >> bit_offset) & mask);
}

HashMap<String, Vector<Vector3>> ChunkMeshBuilder::parse_chunk_positions(
    const Dictionary &chunk_data, 
    int min_section_y, 
    int max_section_y
) {
    HashMap<String, Vector<Vector3>> categorized_positions;

    if (!chunk_data.has("sections")) return categorized_positions;

    const HashMap<String, String> &block_map = get_block_scene_map();

    Array sections = chunk_data["sections"];
    for (int i = 0; i < sections.size(); ++i) {
        Dictionary section = sections[i];
        if (!section.has("block_states") || !section.has("Y")) continue;

        int section_y = section["Y"];
        if (section_y < min_section_y || section_y > max_section_y) continue;

        Dictionary block_states = section["block_states"];

        if (!block_states.has("palette")) continue;
        Array palette = block_states["palette"];
        if (palette.is_empty()) continue;

        PackedInt64Array data;
        if (block_states.has("data")) {
            data = block_states["data"];
        }

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int palette_idx = 0;
                    if (palette.size() > 1) {
                        palette_idx = get_palette_index(data, palette.size(), x, y, z);
                    }

                    if (palette_idx >= 0 && palette_idx < palette.size()) {
                        Dictionary block = palette[palette_idx];
                        if (block.has("Name")) {
                            String block_name = block["Name"];
                            
                            if (block_name != "minecraft:air" && block_map.has(block_name)) {
                                Vector3 pos(
                                    static_cast<float>(x),
                                    static_cast<float>((section_y * 16) + y),
                                    static_cast<float>(z)
                                );
                                categorized_positions[block_name].append(pos);
                            }
                        }
                    }
                }
            }
        }
    }

    return categorized_positions;
}

BuiltChunkData ChunkMeshBuilder::build_chunk_data_async(const HashMap<String, Vector<Vector3>> &categorized_positions) {
    BuiltChunkData result;
    const HashMap<String, String> &block_map = get_block_scene_map();

    HashSet<Vector3i> occupied_blocks;

    // 各ブロックのインスタンス計算 & MultiMesh リソース生成
    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        if (!block_map.has(block_name) || positions.is_empty()) continue;

        String scene_path = block_map[block_name];
        BlockMeshData mesh_data = get_block_mesh_data(scene_path);
        if (!mesh_data.valid || mesh_data.mesh.is_null()) continue;

        Ref<MultiMesh> mm;
        mm.instantiate();
        mm->set_transform_format(MultiMesh::TRANSFORM_3D);
        mm->set_mesh(mesh_data.mesh);
        mm->set_instance_count(positions.size());

        for (int i = 0; i < positions.size(); ++i) {
            Vector3 pos = positions[i];
            Transform3D t;
            t.origin = pos;
            mm->set_instance_transform(i, t);

            Vector3i grid_pos(
                static_cast<int>(std::floor(pos.x + 0.5f)),
                static_cast<int>(std::floor(pos.y + 0.5f)),
                static_cast<int>(std::floor(pos.z + 0.5f))
            );
            occupied_blocks.insert(grid_pos);
        }

        result.multimeshes[block_name] = mm;
    }

    // コリジョン用ポリゴン頂点データの事前計算（1つのBoxデータ）
    static const Vector3 box_verts[36] = {
        // Front
        {-0.5f,-0.5f, 0.5f}, { 0.5f,-0.5f, 0.5f}, { 0.5f, 0.5f, 0.5f},
        {-0.5f,-0.5f, 0.5f}, { 0.5f, 0.5f, 0.5f}, {-0.5f, 0.5f, 0.5f},
        // Back
        { 0.5f,-0.5f,-0.5f}, {-0.5f,-0.5f,-0.5f}, {-0.5f, 0.5f,-0.5f},
        { 0.5f,-0.5f,-0.5f}, {-0.5f, 0.5f,-0.5f}, { 0.5f, 0.5f,-0.5f},
        // Top
        {-0.5f, 0.5f, 0.5f}, { 0.5f, 0.5f, 0.5f}, { 0.5f, 0.5f,-0.5f},
        {-0.5f, 0.5f, 0.5f}, { 0.5f, 0.5f,-0.5f}, {-0.5f, 0.5f,-0.5f},
        // Bottom
        {-0.5f,-0.5f,-0.5f}, { 0.5f,-0.5f,-0.5f}, { 0.5f,-0.5f, 0.5f},
        {-0.5f,-0.5f,-0.5f}, { 0.5f,-0.5f, 0.5f}, {-0.5f,-0.5f, 0.5f},
        // Right
        { 0.5f,-0.5f, 0.5f}, { 0.5f,-0.5f,-0.5f}, { 0.5f, 0.5f,-0.5f},
        { 0.5f,-0.5f, 0.5f}, { 0.5f, 0.5f,-0.5f}, { 0.5f, 0.5f, 0.5f},
        // Left
        {-0.5f,-0.5f,-0.5f}, {-0.5f,-0.5f, 0.5f}, {-0.5f, 0.5f, 0.5f},
        {-0.5f,-0.5f,-0.5f}, {-0.5f, 0.5f, 0.5f}, {-0.5f, 0.5f,-0.5f}
    };

    for (const Vector3i &grid_pos : occupied_blocks) {
        bool is_surrounded = 
            occupied_blocks.has(grid_pos + Vector3i(1, 0, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(-1, 0, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, 1, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, -1, 0)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, 0, 1)) &&
            occupied_blocks.has(grid_pos + Vector3i(0, 0, -1));

        if (is_surrounded) continue;

        Vector3 offset(grid_pos.x, grid_pos.y, grid_pos.z);
        for (int i = 0; i < 36; ++i) {
            result.collision_faces.append(box_verts[i] + offset);
        }
    }

    return result;
}

void ChunkMeshBuilder::apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkData &built_data) {
    if (!parent_node) return;

    // メッシュの配置
    for (const auto &E : built_data.multimeshes) {
        MultiMeshInstance3D *mmi = memnew(MultiMeshInstance3D);
        mmi->set_multimesh(E.value);
        parent_node->add_child(mmi);
    }

    if (built_data.collision_faces.size() > 0) {
        StaticBody3D *static_body = memnew(StaticBody3D);
        static_body->set_collision_layer(1);
        static_body->set_collision_mask(1);

        CollisionShape3D *col_shape = memnew(CollisionShape3D);
        Ref<ConcavePolygonShape3D> polygon_shape;
        polygon_shape.instantiate();
        polygon_shape->set_faces(built_data.collision_faces);

        col_shape->set_shape(polygon_shape);
        static_body->add_child(col_shape);
        parent_node->add_child(static_body);
    }
}