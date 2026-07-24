#include "chunk_mesh_builder.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>
#include <algorithm>

using namespace godot;

// ブロック名とシーンファイルの対応表
const HashMap<String, String>& ChunkMeshBuilder::get_block_scene_map() {
    static HashMap<String, String> map;
    if (map.is_empty()) {
        map["minecraft:grass_block"]   = "res://GrassBlock.tscn";
        map["minecraft:stone"]         = "res://Stone.tscn";
        map["minecraft:stone_bricks"]  = "res://StoneBricks.tscn";
        map["minecraft:gold_block"]    = "res://GoldBlock.tscn";
        map["minecraft:dirt"]          = "res://GrassBlock.tscn";
    }
    return map;
}

int ChunkMeshBuilder::get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z) {
    if (data.is_empty() || palette_size <= 0) return 0;
    int block_index = y * 256 + z * 16 + x;
    int bits_per_block = std::max(4, (int)std::ceil(std::log2(palette_size)));
    int blocks_per_long = 64 / bits_per_block;
    int long_index = block_index / blocks_per_long;
    int bit_offset = (block_index % blocks_per_long) * bits_per_block;

    if (long_index >= data.size()) return 0;
    uint64_t mask = (1ULL << bits_per_block) - 1;
    return static_cast<int>((static_cast<uint64_t>(data[long_index]) >> bit_offset) & mask);
}

// .tscn からメッシュとマテリアルを抽出してキャッシュ
BlockMeshData ChunkMeshBuilder::get_block_mesh_data(const String &scene_path) {
    static HashMap<String, BlockMeshData> cache;
    if (cache.has(scene_path)) {
        return cache[scene_path];
    }

    BlockMeshData data;
    Ref<PackedScene> scene = ResourceLoader::get_singleton()->load(scene_path);
    if (scene.is_valid()) {
        Node *inst = scene->instantiate();
        Node3D *node_3d = Object::cast_to<Node3D>(inst);
        if (node_3d) {
            for (int i = 0; i < node_3d->get_child_count(); ++i) {
                MeshInstance3D *mi = Object::cast_to<MeshInstance3D>(node_3d->get_child(i));
                if (mi && mi->get_mesh().is_valid()) {
                    data.mesh = mi->get_mesh();
                    data.material = mi->get_material_override();
                    data.valid = true;
                    break;
                }
            }
        }
        if (inst) inst->queue_free();
    }

    // メッシュが取得できなかった場合のフォールバック
    if (!data.valid) {
        Ref<BoxMesh> box;
        box.instantiate();
        box->set_size(Vector3(1.0f, 1.0f, 1.0f));
        data.mesh = box;
        data.valid = true;
    }

    cache[scene_path] = data;
    return data;
}

// 多重描画（MultiMeshInstance3D）ノード生成
void ChunkMeshBuilder::build_multimesh_for_block(Node3D *parent_node, const String &scene_path, const Vector<Vector3> &positions) {
    if (positions.is_empty()) return;

    BlockMeshData mesh_data = get_block_mesh_data(scene_path);

    Ref<MultiMesh> multimesh;
    multimesh.instantiate();
    multimesh->set_transform_format(MultiMesh::TRANSFORM_3D);
    multimesh->set_mesh(mesh_data.mesh);
    multimesh->set_instance_count(positions.size());

    for (int i = 0; i < positions.size(); ++i) {
        Transform3D t;
        t.origin = positions[i];
        multimesh->set_instance_transform(i, t);
    }

    MultiMeshInstance3D *mm_node = memnew(MultiMeshInstance3D);
    mm_node->set_multimesh(multimesh);
    if (mesh_data.material.is_valid()) {
        mm_node->set_material_override(mesh_data.material);
    }

    parent_node->add_child(mm_node);
}

void ChunkMeshBuilder::build_mesh_and_collision(Node3D *parent_node, const Dictionary &chunk_nbt) {
    if (parent_node == nullptr || chunk_nbt.is_empty()) return;

    Dictionary root = chunk_nbt.get("", Dictionary());
    if (!root.has("sections")) return;

    Array sections = root["sections"];
    const HashMap<String, String> &block_map = get_block_scene_map();

    // 各ブロックごとの座標リストを管理するマップ
    HashMap<String, Vector<Vector3>> categorized_positions;

    for (int s = 0; s < sections.size(); ++s) {
        Dictionary section = sections[s];
        if (!section.has("block_states")) continue;

        Dictionary block_states = section["block_states"];
        if (!block_states.has("palette")) continue;

        Array palette = block_states["palette"];
        int section_y = section.has("Y") ? (int)section["Y"] : 0;
        PackedInt64Array data = block_states.has("data") ? (PackedInt64Array)block_states["data"] : PackedInt64Array();

        for (int y = 0; y < 16; ++y) {
            for (int z = 0; z < 16; ++z) {
                for (int x = 0; x < 16; ++x) {
                    int p_index = get_palette_index(data, palette.size(), x, y, z);
                    if (p_index < 0 || p_index >= palette.size()) continue;

                    Dictionary block_type = palette[p_index];
                    String name = block_type.has("Name") ? (String)block_type["Name"] : "";

                    // 空気ブロック、または対応表（block_map）に存在しない未知のブロックは無生成（スキップ）
                    if (name == "minecraft:air" || name.is_empty() || !block_map.has(name)) {
                        continue;
                    }

                    Vector3 block_pos(x, section_y * 16 + y, z);

                    // 対応表にある登録済みブロックのみ座標を保存
                    categorized_positions[name].push_back(block_pos);
                }
            }
        }
    }

    // 分類された登録済みブロックごとに MultiMeshInstance3D を生成
    for (const auto &E : categorized_positions) {
        String block_name = E.key;
        const Vector<Vector3> &positions = E.value;

        if (block_map.has(block_name)) {
            build_multimesh_for_block(parent_node, block_map[block_name], positions);
        }
    }
}