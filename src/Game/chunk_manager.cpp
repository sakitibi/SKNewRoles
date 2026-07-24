#include "chunk_manager.h"
#include "mca_parser.h"
#include "chunk_mesh_builder.h"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_chunk_size"), &ChunkManager::get_chunk_size);
    ClassDB::bind_method(D_METHOD("set_chunk_size", "p_size"), &ChunkManager::set_chunk_size);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "chunk_size"), "set_chunk_size", "get_chunk_size");

    ClassDB::bind_method(D_METHOD("get_render_distance"), &ChunkManager::get_render_distance);
    ClassDB::bind_method(D_METHOD("set_render_distance", "p_dist"), &ChunkManager::set_render_distance);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "render_distance"), "set_render_distance", "get_render_distance");

    ClassDB::bind_method(D_METHOD("get_player_path"), &ChunkManager::get_player_path);
    ClassDB::bind_method(D_METHOD("set_player_path", "p_path"), &ChunkManager::set_player_path);
    ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, "player_path"), "set_player_path", "get_player_path");

    // シグナルのバインド
    ADD_SIGNAL(MethodInfo("chunk_loaded", PropertyInfo(Variant::VECTOR2I, "coord"), PropertyInfo(Variant::OBJECT, "chunk_node")));
    ADD_SIGNAL(MethodInfo("chunk_unloaded", PropertyInfo(Variant::VECTOR2I, "coord")));
}

ChunkManager::ChunkManager() {}
ChunkManager::~ChunkManager() {}

void ChunkManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    if (player_node == nullptr || !player_node->is_inside_tree()) {
        player_node = find_local_player();
    }

    if (player_node != nullptr) {
        Vector3 player_pos = player_node->get_global_position();
        Vector2i new_coord(
            static_cast<int>(std::floor(player_pos.x / chunk_size)),
            static_cast<int>(std::floor(player_pos.z / chunk_size))
        );

        if (first_update || new_coord != current_chunk_coord) {
            current_chunk_coord = new_coord;
            first_update = false;
            update_chunks_around_player();
        }
    }
}

void ChunkManager::load_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord)) return;

    // 1. チャンク親ノード作成
    Node3D *chunk_node = memnew(Node3D);
    chunk_node->set_name("Chunk_" + String::num_int64(coord.x) + "_" + String::num_int64(coord.y));

    // 2. MCAパース（MCAParser ヘルパーを使用）
    MCAParser parser;
    Dictionary chunk_nbt = parser.parse_chunk(region_folder_path, coord.x, coord.y);

    // 3. メッシュとアタリ判定の生成（ChunkMeshBuilder ヘルパーを使用）
    if (!chunk_nbt.is_empty()) {
        ChunkMeshBuilder::build_mesh_and_collision(chunk_node, chunk_nbt);
    }

    // 4. トランスフォーム調整と追加
    chunk_node->set_position(Vector3(coord.x * chunk_size, 0.0f, coord.y * chunk_size));
    add_child(chunk_node);

    loaded_chunks[coord] = chunk_node;
    emit_signal("chunk_loaded", coord, chunk_node);
}

void ChunkManager::unload_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord)) {
        Node3D *node = loaded_chunks[coord];
        if (node && node->is_inside_tree()) {
            node->queue_free();
        }
        loaded_chunks.erase(coord);
        emit_signal("chunk_unloaded", coord);
    }
}

void ChunkManager::update_chunks_around_player() {
    HashMap<Vector2i, bool> keep;
    for (int x = -render_distance; x <= render_distance; ++x) {
        for (int z = -render_distance; z <= render_distance; ++z) {
            Vector2i target = current_chunk_coord + Vector2i(x, z);
            keep[target] = true;
            if (!loaded_chunks.has(target)) load_chunk(target);
        }
    }

    Array loaded_coords;
    for (const auto &E : loaded_chunks) loaded_coords.append(E.key);
    for (int i = 0; i < loaded_coords.size(); ++i) {
        Vector2i coord = loaded_coords[i];
        if (!keep.has(coord)) unload_chunk(coord);
    }
}

Node3D *ChunkManager::find_local_player() {
    if (!player_path.is_empty()) {
        Node *n = get_node_or_null(player_path);
        if (n != nullptr) return Object::cast_to<Node3D>(n);
    }

    SceneTree *tree = get_tree();
    if (!tree) return nullptr;

    Array players = tree->get_nodes_in_group("LocalPlayer");
    return (players.size() > 0) ? Object::cast_to<Node3D>(players[0]) : nullptr;
}

// Getter / Setter
void ChunkManager::set_chunk_size(float p_size) { chunk_size = p_size; }
float ChunkManager::get_chunk_size() const { return chunk_size; }
void ChunkManager::set_render_distance(int p_dist) { render_distance = p_dist; }
int ChunkManager::get_render_distance() const { return render_distance; }
void ChunkManager::set_player_path(const NodePath &p_path) { player_path = p_path; }
NodePath ChunkManager::get_player_path() const { return player_path; }