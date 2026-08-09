#include "chunk_manager.h"
#include "chunk_loader.h"
#include "chunk_veritier.h"
#include "chunk_spawner.h"
#include "chunk_block_editor.h"
#include "../../../Blocks/block_mesh_cache.h"

#include <godot_cpp/core/object.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>

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
    ClassDB::bind_method(D_METHOD("verity_initial_collisions"), &ChunkManager::verity_initial_collisions);

    ClassDB::bind_method(D_METHOD("spawn_falling_block", "spawn_pos", "block_type"), &ChunkManager::spawn_falling_block, DEFVAL("stone"));
    ClassDB::bind_method(D_METHOD("_on_block_landed", "land_pos", "block_type"), &ChunkManager::_on_block_landed);

    ClassDB::bind_method(D_METHOD("_on_chunk_loaded", "p_userdata"), &ChunkManager::_on_chunk_loaded);
}

ChunkManager::ChunkManager() {}
ChunkManager::~ChunkManager() {}

void ChunkManager::spawn_falling_block(const Vector3 &spawn_pos, const String &block_type) {
    ChunkSpawner::spawn_falling_block(this, spawn_pos, block_type);
}

void ChunkManager::_on_block_landed(const Vector3 &land_pos, const String &block_type) {
    UtilityFunctions::print(vformat("[ChunkManager] Block (%s) landed at: ", block_type), land_pos);
    ChunkBlockEditor::add_block_at_world_pos(loaded_chunks, chunk_block_data_map, chunk_size, land_pos, block_type);
}

Node3D *ChunkManager::find_local_player() {
    if (player_instance_id != 0) {
        if (UtilityFunctions::is_instance_id_valid(player_instance_id)) {
            Object *obj = ObjectDB::get_instance(player_instance_id);
            if (obj) {
                Node3D *p = Object::cast_to<Node3D>(obj);
                if (p && p->is_inside_tree()) return p;
            }
        }
        player_instance_id = 0;
    }

    if (!player_path.is_empty()) {
        Node *node = get_node_or_null(player_path);
        if (node) {
            Node3D *p = Object::cast_to<Node3D>(node);
            if (p) {
                player_instance_id = p->get_instance_id();
                return p;
            }
        }
    }

    SceneTree *st = get_tree();
    if (st) {
        Array players = st->get_nodes_in_group("player");
        if (players.size() > 0) {
            Node3D *p = Object::cast_to<Node3D>(players[0]);
            if (p) {
                player_instance_id = p->get_instance_id();
                return p;
            }
        }

        Node *root = st->get_current_scene();
        if (root) {
            Node *p_node = root->find_child("MyPlayer", true, false);
            if (!p_node) p_node = root->find_child("Player", true, false);
            if (p_node) {
                Node3D *p = Object::cast_to<Node3D>(p_node);
                if (p) {
                    player_instance_id = p->get_instance_id();
                    return p;
                }
            }
        }
    }

    return nullptr;
}

void ChunkManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;

    set_process(true);

    UtilityFunctions::print("[ChunkManager] _ready() called. Starting BlockMeshCache::preload_block_meshes()...");
    BlockMeshCache::preload_block_meshes();
    UtilityFunctions::print("[ChunkManager] BlockMeshCache::preload_block_meshes() completed successfully.");
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    Vector3 center_pos = Vector3(0, 0, 0);
    Node3D *player = find_local_player();
    
    if (player) {
        center_pos = player->get_global_position();
    } else {
        static float log_timer = 0.0f;
        log_timer += delta;
        if (log_timer >= 3.0f) {
            UtilityFunctions::print("[ChunkManager] Searching for MyPlayer... Operating with fallback center (0,0,0)");
            log_timer = 0.0f;
        }
    }

    Vector2i new_chunk_coord = Vector2i(
        std::floor(center_pos.x / chunk_size),
        std::floor(center_pos.z / chunk_size)
    );

    if (first_update || new_chunk_coord != current_chunk_coord) {
        first_update = false;
        current_chunk_coord = new_chunk_coord;
        UtilityFunctions::print(vformat("[ChunkManager] Player position updated -> Chunk Coord: (%d, %d)", new_chunk_coord.x, new_chunk_coord.y));
        update_chunks_around_player();
    }
}

void ChunkManager::update_chunks_around_player() {
    Vector3 center_pos = Vector3(0, 0, 0);
    Node3D *player = find_local_player();
    if (player) {
        center_pos = player->get_global_position();
    }

    Vector2i player_coord = Vector2i(
        std::floor(center_pos.x / chunk_size),
        std::floor(center_pos.z / chunk_size)
    );

    HashSet<Vector2i> required_chunks;

    for (int x = -render_distance; x <= render_distance; ++x) {
        for (int z = -render_distance; z <= render_distance; ++z) {
            required_chunks.insert(player_coord + Vector2i(x, z));
        }
    }

    Vector<Vector2i> chunks_to_unload;
    for (const KeyValue<Vector2i, Node3D *> &E : loaded_chunks) {
        if (!required_chunks.has(E.key)) {
            chunks_to_unload.push_back(E.key);
        }
    }

    for (int i = 0; i < chunks_to_unload.size(); ++i) {
        unload_chunk(chunks_to_unload[i]);
    }

    int requested = 0;
    for (const Vector2i &coord : required_chunks) {
        if (!loaded_chunks.has(coord) && !pending_tasks.has(coord)) {
            load_chunk(coord);
            requested++;
        }
    }

    UtilityFunctions::print(vformat("[ChunkManager] Chunk update: requested=%d / pending=%d / loaded=%d", 
        requested, pending_tasks.size(), loaded_chunks.size()));

    if (!initial_load_complete && pending_tasks.is_empty()) {
        initial_load_complete = true;
        call_deferred("verity_initial_collisions");
        UtilityFunctions::print("[ChunkManager] Initial chunk loading completed.");
    }
}

void ChunkManager::load_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord) || pending_tasks.has(coord)) return;

    UtilityFunctions::print(vformat("[ChunkManager] Queueing chunk task for coord: (%d, %d)", coord.x, coord.y));

    ChunkLoadData *load_data = new ChunkLoadData();
    load_data->coord = coord;
    load_data->chunk_size = chunk_size;
    load_data->region_folder_path = region_folder_path;
    load_data->is_initial_load = !initial_load_complete;

    int64_t task_id = WorkerThreadPool::get_singleton()->add_task(
        Callable(this, "_on_chunk_loaded").bind(load_data),
        true
    );

    pending_tasks[coord] = task_id;
}

void ChunkManager::_on_chunk_loaded(Variant p_userdata) {
    ChunkLoadData *data = (ChunkLoadData *)p_userdata.operator uint64_t();
    if (!data) return;

    Vector2i coord = data->coord;
    pending_tasks.erase(coord);

    if (data->has_data) {
        Node3D *chunk_node = ChunkLoader::create_chunk_node(coord, chunk_size, data->built_data);
        if (chunk_node) {
            call_deferred("add_child", chunk_node);
            loaded_chunks[coord] = chunk_node;
            chunk_block_data_map[coord] = data->categorized_positions;
            UtilityFunctions::print(vformat("[ChunkManager] Chunk (%d, %d) loaded successfully.", coord.x, coord.y));
        }
    }

    delete data;

    if (!initial_load_complete && pending_tasks.is_empty()) {
        initial_load_complete = true;
        call_deferred("verity_initial_collisions");
        UtilityFunctions::print("[ChunkManager] All pending chunk tasks completed. Initial load complete set to true.");
    }
}

void ChunkManager::verity_initial_collisions() {
    UtilityFunctions::print("[ChunkManager] Verifying initial collisions...");
    ChunkVeritier::verity_initial_collisions(loaded_chunks);
}

void ChunkManager::unload_chunk(const Vector2i &coord) {
    if (!loaded_chunks.has(coord)) return;

    Node3D *chunk_node = loaded_chunks[coord];
    loaded_chunks.erase(coord);
    chunk_block_data_map.erase(coord);

    if (chunk_node) {
        chunk_node->queue_free();
    }
    UtilityFunctions::print(vformat("[ChunkManager] Chunk (%d, %d) unloaded.", coord.x, coord.y));
}

void ChunkManager::set_chunk_size(float p_size) { chunk_size = p_size; }
float ChunkManager::get_chunk_size() const { return chunk_size; }

bool ChunkManager::is_initial_load_complete() const { return initial_load_complete; }

void ChunkManager::set_render_distance(int p_dist) { render_distance = p_dist; }
int ChunkManager::get_render_distance() const { return render_distance; }

void ChunkManager::set_player_path(const NodePath &p_path) { player_path = p_path; }
NodePath ChunkManager::get_player_path() const { return player_path; }

void ChunkManager::set_region_folder_path(const String &p_path) { region_folder_path = p_path; }
String ChunkManager::get_region_folder_path() const { return region_folder_path; }