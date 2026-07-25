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

    ClassDB::bind_method(D_METHOD("_on_chunk_loaded", "p_userdata"), &ChunkManager::_on_chunk_loaded);
}

ChunkManager::ChunkManager() {}

ChunkManager::~ChunkManager() {
    while (!loaded_queue.is_empty()) {
        ChunkLoadData *data = loaded_queue.front()->get();
        loaded_queue.pop_front();
        memdelete(data);
    }
}

void ChunkManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;
    
    // ブロックメッシュの事前ロード（初回ロード時のカクつきを防止）
    ChunkMeshBuilder::preload_block_meshes();
}

void ChunkManager::load_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord) || pending_tasks.has(coord)) return;

    ChunkLoadData *data = memnew(ChunkLoadData);
    data->coord = coord;
    data->region_folder_path = region_folder_path;
    data->chunk_size = chunk_size;
    data->manager = this;

    int64_t task_id = WorkerThreadPool::get_singleton()->add_native_task(
        &ChunkManager::_async_load_worker,
        data,
        true,
        "ChunkLoadTask"
    );

    pending_tasks[coord] = task_id;
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

// バックグラウンドスレッド（MCAパースとブロック位置の分類のみ行う）
void ChunkManager::_async_load_worker(void *p_userdata) {
    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data) return;

    // 1. MCAパース (ファイルIO)
    Dictionary chunk_data = MCAParser::parse_chunk(data->region_folder_path, data->coord.x, data->coord.y);

    if (chunk_data.has("sections")) {
        Array sections = chunk_data["sections"];
        // 2. ブロック配置の分類（純粋なCPU計算）
        data->categorized_positions = ChunkMeshBuilder::extract_block_positions(sections);
        data->has_data = true;
    }

    // メインスレッドへコールバック
    if (data->manager) {
        uint64_t ptr_val = reinterpret_cast<uint64_t>(data);
        data->manager->call_deferred("_on_chunk_loaded", ptr_val);
    }
}

void ChunkManager::_on_chunk_loaded(Variant p_userdata) {
    uint64_t ptr_val = p_userdata;
    ChunkLoadData *data = reinterpret_cast<ChunkLoadData *>(ptr_val);
    if (!data) return;

    // 即座にシーングラフに追加せず、キューに追加
    loaded_queue.push_back(data);
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    // --- 1フレームあたり最大1チャンクだけシーンに反映（スパイク防止） ---
    if (!loaded_queue.is_empty()) {
        ChunkLoadData *data = loaded_queue.front()->get();
        loaded_queue.pop_front();

        Vector2i coord = data->coord;
        pending_tasks.erase(coord);

        if (!loaded_chunks.has(coord) && data->has_data) {
            // メインスレッドで安全に Node3D と MultiMesh を生成
            Node3D *chunk_node = memnew(Node3D);
            chunk_node->set_name("Chunk_" + String::num_int64(coord.x) + "_" + String::num_int64(coord.y));
            chunk_node->set_position(Vector3(coord.x * chunk_size, 0, coord.y * chunk_size));

            ChunkMeshBuilder::build_from_positions(chunk_node, data->categorized_positions);

            add_child(chunk_node);
            loaded_chunks[coord] = chunk_node;
        }

        memdelete(data);
    }

    // プレイヤーの追従ロジック
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

Node3D *ChunkManager::find_local_player() {
    if (!player_path.is_empty()) {
        Node *n = get_node_or_null(player_path);
        if (n) return Object::cast_to<Node3D>(n);
    }

    SceneTree *tree = get_tree();
    if (!tree) return nullptr;

    Array players = tree->get_nodes_in_group("LocalPlayer");
    return (players.size() > 0) ? Object::cast_to<Node3D>(players[0]) : nullptr;
}

void ChunkManager::update_chunks_around_player() {
    HashMap<Vector2i, bool> keep;
    for (int x = -render_distance; x <= render_distance; ++x) {
        for (int z = -render_distance; z <= render_distance; ++z) {
            Vector2i target = current_chunk_coord + Vector2i(x, z);
            keep[target] = true;

            if (!loaded_chunks.has(target) && !pending_tasks.has(target)) {
                load_chunk(target);
            }
        }
    }

    Array loaded_coords;
    for (const auto &E : loaded_chunks) {
        loaded_coords.append(E.key);
    }

    for (int i = 0; i < loaded_coords.size(); ++i) {
        Vector2i coord = loaded_coords[i];
        if (!keep.has(coord)) {
            unload_chunk(coord);
        }
    }
}

// Getter / Setter
void ChunkManager::set_chunk_size(float p_size) { chunk_size = p_size; }
float ChunkManager::get_chunk_size() const { return chunk_size; }

void ChunkManager::set_render_distance(int p_dist) { render_distance = p_dist; }
int ChunkManager::get_render_distance() const { return render_distance; }

void ChunkManager::set_player_path(const NodePath &p_path) { player_path = p_path; }
NodePath ChunkManager::get_player_path() const { return player_path; }