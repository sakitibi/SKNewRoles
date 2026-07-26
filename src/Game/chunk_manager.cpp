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

    ClassDB::bind_method(D_METHOD("get_region_folder_path"), &ChunkManager::get_region_folder_path);
    ClassDB::bind_method(D_METHOD("set_region_folder_path", "p_path"), &ChunkManager::set_region_folder_path);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "region_folder_path"), "set_region_folder_path", "get_region_folder_path");

    ClassDB::bind_method(D_METHOD("is_initial_load_complete"), &ChunkManager::is_initial_load_complete);
    ClassDB::bind_method(D_METHOD("_on_chunk_loaded", "p_userdata"), &ChunkManager::_on_chunk_loaded);
}

ChunkManager::ChunkManager() {}

ChunkManager::~ChunkManager() {
    while (!loaded_queue.is_empty()) {
        ChunkLoadData *data = loaded_queue.front()->get();
        loaded_queue.pop_front();
        delete data;
    }
}

void ChunkManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        set_process(false);
        return;
    }

    ChunkMeshBuilder::preload_block_meshes();
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    if (!player_node) {
        player_node = find_local_player();
        if (!player_node && !player_path.is_empty()) {
            Node *node = get_node_or_null(player_path);
            if (node) {
                player_node = Object::cast_to<Node3D>(node);
                if (player_node) {
                    UtilityFunctions::print("[ChunkManager] ✅ player_path からプレイヤーを手動取得しました: ", player_path);
                }
            }
        }
    }

    if (first_update) {
        if (player_node) {
            Vector3 p_pos = player_node->get_global_position();
            current_chunk_coord = Vector2i(
                static_cast<int>(std::floor(p_pos.x / chunk_size)),
                static_cast<int>(std::floor(p_pos.z / chunk_size))
            );
            
            UtilityFunctions::print(vformat(
                "[ChunkManager] 🚀 初回プレイヤー位置検出: Pos(%.1f, %.1f, %.1f) -> チャンク座標(%d, %d)", 
                p_pos.x, p_pos.y, p_pos.z, current_chunk_coord.x, current_chunk_coord.y
            ));

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

    // ロード完了キューの消化（カクつき防止のため1フレームに最大2個までメインスレッドへ適用）
    int processed_this_frame = 0;
    while (!loaded_queue.is_empty() && processed_this_frame < 2) {
        ChunkLoadData *data = loaded_queue.front()->get();
        loaded_queue.pop_front();

        pending_tasks.erase(data->coord);

        if (data->has_data) {
            uint64_t start_apply = Time::get_singleton()->get_ticks_msec();

            Node3D *chunk_node = memnew(Node3D);
            chunk_node->set_position(Vector3(data->coord.x * chunk_size, 0.0f, data->coord.y * chunk_size));
            add_child(chunk_node);

            // サブスレッドでビルド済みのデータをメインスレッドでノードに安全かつ高速にアタッチ
            ChunkMeshBuilder::apply_chunk_data_to_node(chunk_node, data->built_data);
            loaded_chunks[data->coord] = chunk_node;

            uint64_t apply_time = Time::get_singleton()->get_ticks_msec() - start_apply;

            UtilityFunctions::print(vformat(
                "[ChunkManager Main] 🟢 チャンク (%d, %d) Applied to SceneTree in %d ms",
                data->coord.x, data->coord.y, apply_time
            ));
        } else {
            UtilityFunctions::print(vformat(
                "[ChunkManager Main] ⚠️ チャンク (%d, %d) に有効なデータ (has_data=false) がありませんでした。",
                data->coord.x, data->coord.y
            ));
        }

        delete data;
        processed_this_frame++;
    }

    if (!initial_load_complete && pending_tasks.is_empty()) {
        initial_load_complete = true;
    }
}

void ChunkManager::load_chunk(const Vector2i &coord) {
    ChunkLoadData *data = memnew(ChunkLoadData);
    data->coord = coord;
    data->region_folder_path = region_folder_path;
    data->chunk_size = chunk_size;
    data->manager = this;

    Callable worker_callable = Callable(this, "_async_load_worker");
    int64_t task_id = WorkerThreadPool::get_singleton()->add_task(
        Callable(this, "_async_load_worker").bind(Variant(data))
    );
    
    pending_tasks[coord] = task_id;
    UtilityFunctions::print("[ChunkManager] 🧵 非同期タスク登録完了 (TaskID: ", task_id, ") チャンク: X=", coord.x, ", Z=", coord.y);
}

void ChunkManager::_async_load_worker(Variant p_userdata) {
    uint64_t ptr_val = static_cast<uint64_t>(p_userdata);
    ChunkLoadData *data = reinterpret_cast<ChunkLoadData *>(ptr_val);
    if (!data) return;

    MCAParser parser;
    Dictionary chunk_nbt = parser.parse_chunk(data->region_folder_path, data->coord.x, data->coord.y);
    
    if (!chunk_nbt.is_empty()) {
        data->categorized_positions = ChunkMeshBuilder::parse_chunk_positions(chunk_nbt);
        data->has_data = !data->categorized_positions.is_empty();

        // バックグラウンドスレッドでメッシュ・コリジョンを事前ビルド
        if (data->has_data) {
            data->built_data = ChunkMeshBuilder::build_chunk_data_async(data->categorized_positions);
        }
    }

    if (data->manager) {
        data->manager->call_deferred("_on_chunk_loaded", ptr_val);
    }
}

void ChunkManager::_on_chunk_loaded(Variant p_userdata) {
    uint64_t ptr_val = static_cast<uint64_t>(p_userdata);
    ChunkLoadData *data = reinterpret_cast<ChunkLoadData *>(ptr_val);
    if (!data) return;

    // 保留タスクから削除
    pending_tasks.erase(data->coord);

    if (data->has_data) {
        // チャンク用の空ノード（またはNode3D）を生成
        Node3D *chunk_node = memnew(Node3D);
        
        // 座標をワールド位置に変換して配置
        Vector3 world_pos(data->coord.x * data->chunk_size, 0, data->coord.y * data->chunk_size);
        chunk_node->set_position(world_pos);

        ChunkMeshBuilder::apply_chunk_data_to_node(chunk_node, data->built_data);

        // シーンツリーに追加
        add_child(chunk_node);
        loaded_chunks[data->coord] = chunk_node;
    }

    // 動的に確保したデータを解放
    delete data;

    // 初回ロード完了判定
    if (!initial_load_complete && pending_tasks.is_empty()) {
        initial_load_complete = true;
    }
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
    UtilityFunctions::print("[ChunkManager] 🔄 周囲のチャンクをスキャン中 (RenderDistance: ", render_distance, ")");
    
    for (int x = -render_distance; x <= render_distance; ++x) {
        for (int z = -render_distance; z <= render_distance; ++z) {
            Vector2i target = current_chunk_coord + Vector2i(x, z);
            keep[target] = true;

            if (!loaded_chunks.has(target) && !pending_tasks.has(target)) {
                UtilityFunctions::print("[ChunkManager] 📥 新規チャンクのロードを要求: X=", target.x, ", Z=", target.y);
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

void ChunkManager::set_region_folder_path(const String &p_path) { region_folder_path = p_path; }
String ChunkManager::get_region_folder_path() const { return region_folder_path; }