#include "chunk_manager.h"
#include "mca_parser.h"
#include "chunk_mesh_builder.h"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
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

    // call_deferredで呼び出すコールバック関数をバインド
    ClassDB::bind_method(D_METHOD("_on_chunk_loaded", "data"), &ChunkManager::_on_chunk_loaded);
}

ChunkManager::ChunkManager() {}
ChunkManager::~ChunkManager() {}

void ChunkManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    if (!player_node) {
        player_node = find_local_player();
        if (!player_node) return;
    }

    Vector3 player_pos = player_node->get_global_position();
    Vector2i new_chunk_coord(
        static_cast<int>(std::floor(player_pos.x / chunk_size)),
        static_cast<int>(std::floor(player_pos.z / chunk_size))
    );

    if (first_update || new_chunk_coord != current_chunk_coord) {
        current_chunk_coord = new_chunk_coord;
        first_update = false;
        update_chunks_around_player();
    }
}

void ChunkManager::load_chunk(const Vector2i &coord) {
    // 既に読み込み済み、またはロード中の場合は処理しない
    if (loaded_chunks.has(coord) || pending_tasks.has(coord)) return;

    ChunkLoadData *data = memnew(ChunkLoadData);
    data->coord = coord;
    data->region_folder_path = region_folder_path;
    data->chunk_size = chunk_size;

    // バックグラウンドスレッドで読み込み＆メッシュ構築を実行
    int64_t task_id = WorkerThreadPool::get_singleton()->add_native_task(
        &ChunkManager::_async_load_worker,
        data,
        true,
        "ChunkLoadTask"
    );

    pending_tasks[coord] = task_id;
}

// 別スレッド（WorkerThread）側で動作する重い計算処理
void ChunkManager::_async_load_worker(void *p_userdata) {
    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data) return;

    // 1. MCAパース
    Dictionary chunk_data = MCAParser::parse_chunk(data->region_folder_path, data->coord.x, data->coord.y);

    if (chunk_data.has("sections")) {
        Array sections = chunk_data["sections"];

        // 2. メッシュ・コリジョンの構築準備
        data->built_node = memnew(Node3D);
        data->built_node->set_name("Chunk_" + String::num_int64(data->coord.x) + "_" + String::num_int64(data->coord.y));
        data->built_node->set_position(Vector3(data->coord.x * data->chunk_size, 0, data->coord.y * data->chunk_size));

        // メッシュとコリジョンデータの構築
        ChunkMeshBuilder::build_mesh_and_collision(data->built_node, sections);
    }

    Callable callback(data->built_node ? data->built_node->get_parent() : nullptr, "_on_chunk_loaded");
    uint64_t ptr_val = reinterpret_cast<uint64_t>(data);
    data->built_node->call_deferred("call_deferred", "_on_chunk_loaded", ptr_val); 
}

// メインスレッド側で実行されるノード追加処理
void ChunkManager::_on_chunk_loaded(Variant p_userdata) {
    uint64_t ptr_val = p_userdata;
    ChunkLoadData *data = reinterpret_cast<ChunkLoadData *>(ptr_val);
    if (!data) return;

    Vector2i coord = data->coord;
    pending_tasks.erase(coord);

    // プレイヤーが移動して不要になった場合（アンロード対象）
    if (loaded_chunks.has(coord)) {
        if (data->built_node) {
            memdelete(data->built_node);
        }
        memdelete(data);
        return;
    }

    if (data->built_node) {
        add_child(data->built_node);
        loaded_chunks[coord] = data->built_node;
    }

    memdelete(data);
}

void ChunkManager::unload_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord)) {
        Node3D *chunk_node = loaded_chunks[coord];
        loaded_chunks.erase(coord);
        if (chunk_node) {
            chunk_node->queue_free();
        }
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