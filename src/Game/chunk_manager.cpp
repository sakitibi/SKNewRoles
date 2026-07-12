#include "chunk_manager.h"
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkManager::_bind_methods() {
    // プロパティのバインド (Godotインスペクターへ公開)
    ClassDB::bind_method(D_METHOD("get_chunk_size"), &ChunkManager::get_chunk_size);
    ClassDB::bind_method(D_METHOD("set_chunk_size", "p_size"), &ChunkManager::set_chunk_size);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "chunk_size"), "set_chunk_size", "get_chunk_size");

    ClassDB::bind_method(D_METHOD("get_render_distance"), &ChunkManager::get_render_distance);
    ClassDB::bind_method(D_METHOD("set_render_distance", "p_dist"), &ChunkManager::set_render_distance);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "render_distance"), "set_render_distance", "get_render_distance");

    ClassDB::bind_method(D_METHOD("get_player_path"), &ChunkManager::get_player_path);
    ClassDB::bind_method(D_METHOD("set_player_path", "p_path"), &ChunkManager::set_player_path);
    ADD_PROPERTY(PropertyInfo(Variant::NODE_PATH, "player_path"), "set_player_path", "get_player_path");

    // シグナルの登録
    ADD_SIGNAL(MethodInfo("chunk_loaded", PropertyInfo(Variant::VECTOR2I, "coord"), PropertyInfo(Variant::OBJECT, "chunk_node", PROPERTY_HINT_RESOURCE_TYPE, "Node3D")));
    ADD_SIGNAL(MethodInfo("chunk_unloaded", PropertyInfo(Variant::VECTOR2I, "coord")));
}

ChunkManager::ChunkManager() {}
ChunkManager::~ChunkManager() {}

void ChunkManager::_ready() {
    // エディタ実行中（ツールモード等）なら動作させない
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    player_node = find_local_player();
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // プレイヤー未取得の場合は再検索
    if (player_node == nullptr) {
        player_node = find_local_player();
        if (player_node == nullptr) {
            return; // プレイヤーが見つからなければ待機
        }
    }

    update_chunks_around_player();
}

void ChunkManager::update_chunks_around_player() {
    if (player_node == nullptr) return;

    Vector3 player_pos = player_node->get_global_position();
    
    // プレイヤーの現在 Chunk 座標の計算
    int center_x = static_cast<int>(std::floor(player_pos.x / chunk_size));
    int center_z = static_cast<int>(std::floor(player_pos.z / chunk_size));
    Vector2i new_chunk_coord = Vector2i(center_x, center_z);

    // Chunk が切り替わった場合、または初回更新時に読み込みを実行
    if (first_update || new_chunk_coord != current_chunk_coord) {
        current_chunk_coord = new_chunk_coord;
        first_update = false;

        // 範囲内のChunk座標リストを作成
        HashMap<Vector2i, bool> required_chunks;
        for (int x = -render_distance; x <= render_distance; ++x) {
            for (int z = -render_distance; z <= render_distance; ++z) {
                Vector2i coord = Vector2i(center_x + x, center_z + z);
                required_chunks[coord] = true;

                // ロードされていないChunkをロード
                if (!loaded_chunks.has(coord)) {
                    load_chunk(coord);
                }
            }
        }

        Vector<Vector2i> chunks_to_remove;

        // イテレータで HashMap をループ (pair.key で Vector2i キーを取得)
        for (const auto &pair : loaded_chunks) {
            Vector2i coord = pair.key;
            if (!required_chunks.has(coord)) {
                chunks_to_remove.push_back(coord);
            }
        }

        // 範囲外の Chunk をまとめて削除
        for (int i = 0; i < chunks_to_remove.size(); ++i) {
            unload_chunk(chunks_to_remove[i]);
        }
    }
}

void ChunkManager::load_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord)) return;

    ResourceLoader *loader = ResourceLoader::get_singleton();

    // 1. 座標固有のシーンパスを動的生成 (例: res://Scenes/Gamemaps/Chunks/Chunk_0_0.tscn)
    String specific_path = String("res://Scenes/Gamemaps/Chunks/Chunk_") + String::num_int64(coord.x) + "_" + String::num_int64(coord.y) + ".tscn";
    String default_path = "res://Scenes/Gamemaps/Chunks/Chunk_Default.tscn";

    String target_path;

    // 2. 固有のファイルが存在すれば使用し、無ければデフォルトにフォールバック
    if (loader->exists(specific_path)) {
        target_path = specific_path;
    } else if (loader->exists(default_path)) {
        target_path = default_path;
    } else {
        UtilityFunctions::printerr("❌ [ChunkManager] Chunkプレハブが見つかりません (固有・デフォルト両方なし): ", specific_path);
        return;
    }

    // 3. シーンのロードとインスタンス化
    Ref<PackedScene> chunk_scene = loader->load(target_path);
    if (chunk_scene.is_null()) {
        UtilityFunctions::printerr("❌ [ChunkManager] シーンのロードに失敗しました: ", target_path);
        return;
    }

    Node3D *chunk_instance = Object::cast_to<Node3D>(chunk_scene->instantiate());
    if (chunk_instance == nullptr) return;

    Vector3 spawn_pos = Vector3(coord.x * chunk_size, 0.0f, coord.y * chunk_size);
    chunk_instance->set_position(spawn_pos);
    
    add_child(chunk_instance);

    loaded_chunks[coord] = chunk_instance;

    // シグナルの発火
    emit_signal("chunk_loaded", coord, chunk_instance);
    UtilityFunctions::print("🧱 [ChunkManager] Chunkを生成しました [", target_path, "]: (", coord.x, ", ", coord.y, ")");
}

void ChunkManager::unload_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord)) {
        Node3D *chunk_node = loaded_chunks[coord];
        if (chunk_node != nullptr && chunk_node->is_inside_tree()) {
            chunk_node->queue_free();
        }
        loaded_chunks.erase(coord);

        // シグナルの発火
        emit_signal("chunk_unloaded", coord);
    }
}

Node3D *ChunkManager::find_local_player() {
    // 1. ノードパス指定があればそこから取得
    if (!player_path.is_empty()) {
        Node *n = get_node_or_null(player_path);
        if (n != nullptr) {
            return Object::cast_to<Node3D>(n);
        }
    }

    // 2. グループ "LocalPlayer" から検索
    SceneTree *tree = get_tree();
    if (tree == nullptr) return nullptr;

    Array players = tree->get_nodes_in_group("LocalPlayer");
    if (players.size() > 0) {
        return Object::cast_to<Node3D>(players[0]);
    }
    return nullptr;
}

// Getter / Setter 実装
void ChunkManager::set_chunk_size(float p_size) {
    chunk_size = p_size;
}

float ChunkManager::get_chunk_size() const {
    return chunk_size;
}

void ChunkManager::set_render_distance(int p_dist) {
    render_distance = p_dist;
}

int ChunkManager::get_render_distance() const {
    return render_distance;
}

void ChunkManager::set_player_path(const NodePath &p_path) {
    player_path = p_path;
}

NodePath ChunkManager::get_player_path() const {
    return player_path;
}