#include "chunk_manager.h"
#include "mca_parser.h"
#include "chunk_mesh_builder.h"

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/classes/time.hpp>
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

    ClassDB::bind_method(D_METHOD("is_initial_load_complete"), &ChunkManager::is_initial_load_complete);
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

    ChunkMeshBuilder::preload_block_meshes();
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    // プレイヤー位置の追跡と周縁チャンク更新
    if (first_update) {
        player_node = find_local_player();
        if (player_node) {
            current_chunk_coord = Vector2i(
                static_cast<int>(std::floor(player_node->get_global_position().x / chunk_size)),
                static_cast<int>(std::floor(player_node->get_global_position().z / chunk_size))
            );
            update_chunks_around_player();
            first_update = false;
        }
    } else if (player_node) {
        Vector2i new_coord = Vector2i(
            static_cast<int>(std::floor(player_node->get_global_position().x / chunk_size)),
            static_cast<int>(std::floor(player_node->get_global_position().z / chunk_size))
        );
        if (new_coord != current_chunk_coord) {
            current_chunk_coord = new_coord;
            update_chunks_around_player();
        }
    }

    // ロード完了キューの消化（メインスレッドでのノード追加）
    while (!loaded_queue.is_empty()) {
        ChunkLoadData *data = loaded_queue.front()->get();
        loaded_queue.pop_front();

        pending_tasks.erase(data->coord);

        if (data->has_data) {
            uint64_t start_apply = Time::get_singleton()->get_ticks_msec();

            Node3D *chunk_node = memnew(Node3D);
            chunk_node->set_position(Vector3(data->coord.x * chunk_size, 0.0f, data->coord.y * chunk_size));
            add_child(chunk_node);

            ChunkMeshBuilder::apply_chunk_data_to_node(chunk_node, data->built_data);
            loaded_chunks[data->coord] = chunk_node;

            uint64_t apply_time = Time::get_singleton()->get_ticks_msec() - start_apply;

            UtilityFunctions::print(vformat(
                "[ChunkManager Main] Chunk (%d, %d) Applied to SceneTree in %d ms",
                data->coord.x, data->coord.y, apply_time
            ));
        }

        delete data;
    }

    if (!initial_load_complete && pending_tasks.is_empty()) {
        initial_load_complete = true;
    }
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

void ChunkManager::_async_load_worker(void *p_userdata) {
    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data) return;

    uint64_t start_total = Time::get_singleton()->get_ticks_msec();

    // MCAパース処理
    uint64_t start_parse = Time::get_singleton()->get_ticks_msec();
    MCAParser parser;
    Dictionary chunk_nbt = parser.parse_chunk(data->region_folder_path, data->coord.x, data->coord.y);
    
    if (!chunk_nbt.is_empty()) {
        data->categorized_positions = ChunkMeshBuilder::parse_chunk_positions(chunk_nbt);
        data->has_data = !data->categorized_positions.is_empty();
    }
    uint64_t parse_time = Time::get_singleton()->get_ticks_msec() - start_parse;

    // メッシュ＆コリジョンビルド処理 (データが存在する場合)
    uint64_t build_time = 0;
    if (data->has_data) {
        uint64_t start_build = Time::get_singleton()->get_ticks_msec();
        data->built_data = ChunkMeshBuilder::build_chunk_data_async(data->categorized_positions);
        build_time = Time::get_singleton()->get_ticks_msec() - start_build;
    }

    uint64_t total_time = Time::get_singleton()->get_ticks_msec() - start_total;

    // 非同期スレッドからのログ出力
    UtilityFunctions::print(vformat(
        "[ChunkManager Async] Chunk (%d, %d) Loaded in %d ms | Parse NBT: %d ms | Build Mesh/Col: %d ms",
        data->coord.x, data->coord.y, total_time, parse_time, build_time
    ));

    // メインスレッド処理待ち行列へ安全に送信
    if (data->manager) {
        data->manager->call_deferred("_on_chunk_loaded", Variant(data));
    }
}

void ChunkManager::_on_chunk_loaded(Variant p_userdata) {
    uint64_t ptr_val = p_userdata;
    ChunkLoadData *data = reinterpret_cast<ChunkLoadData *>(ptr_val);
    if (!data) return;

    loaded_queue.push_back(data);
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

bool ChunkManager::is_initial_load_complete() const { return initial_load_complete; }

void ChunkManager::set_render_distance(int p_dist) { render_distance = p_dist; }
int ChunkManager::get_render_distance() const { return render_distance; }

void ChunkManager::set_player_path(const NodePath &p_path) { player_path = p_path; }
NodePath ChunkManager::get_player_path() const { return player_path; }