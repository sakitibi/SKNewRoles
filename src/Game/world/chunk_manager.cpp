#include "chunk_manager.h"
#include "mca_parser.h"
#include "chunk_mesh_builder.h"
#include "chunk_block_editor.h"
#include "../../Blocks/block_mesh_cache.h"

#include <godot_cpp/core/object.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
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
    ClassDB::bind_method(D_METHOD("_on_chunk_loaded", "p_userdata"), &ChunkManager::_on_chunk_loaded);

    ClassDB::bind_method(D_METHOD("spawn_falling_block", "spawn_pos", "block_type"), &ChunkManager::spawn_falling_block, DEFVAL("stone"));
    ClassDB::bind_method(D_METHOD("_on_block_landed", "land_pos", "block_type"), &ChunkManager::_on_block_landed);
}

ChunkManager::ChunkManager() {}
ChunkManager::~ChunkManager() {}

void ChunkManager::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) return;
    BlockMeshCache::preload_block_meshes();
}

void ChunkManager::spawn_falling_block(const Vector3 &spawn_pos, const String &block_type) {
    Ref<PackedScene> falling_scene = ResourceLoader::get_singleton()->load("res://FallingBlock.tscn");
    if (falling_scene.is_null()) {
        UtilityFunctions::printerr("[ChunkManager ERROR] FallingBlock.tscn Failed to load");
        return;
    }

    SNR2FallingBlock *block = Object::cast_to<SNR2FallingBlock>(falling_scene->instantiate());
    if (block != nullptr) {
        block->set_global_position(spawn_pos);
        block->set_block_type(block_type);
        block->connect("block_landed", Callable(this, "_on_block_landed"));

        add_child(block);
        UtilityFunctions::print(vformat("[ChunkManager] Falling block (%s) was generated: ", block_type), spawn_pos);
    }
}

void ChunkManager::_on_block_landed(const Vector3 &land_pos, const String &block_type) {
    UtilityFunctions::print(vformat("🧱 [ChunkManager] block (%s) has landed: ", block_type), land_pos);
    ChunkBlockEditor::add_block_at_world_pos(loaded_chunks, chunk_block_data_map, chunk_size, land_pos, block_type);
}

Node3D *ChunkManager::find_local_player() {
    // 保存済み ID が生きているか確認して取得
    if (player_instance_id != 0) {
        if (UtilityFunctions::is_instance_id_valid(player_instance_id)) {
            Object *obj = ObjectDB::get_instance(player_instance_id);
            if (obj) {
                return Object::cast_to<Node3D>(obj);
            }
        }
        player_instance_id = 0; // 無効化されていたらリセット
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
    }

    return nullptr;
}

void ChunkManager::_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint()) return;

    Node3D *p_node = find_local_player();

    if (first_update) {
        if (p_node) {
            Vector3 p_pos = p_node->get_global_position();
            current_chunk_coord = Vector2i(
                static_cast<int>(std::floor(p_pos.x / chunk_size)),
                static_cast<int>(std::floor(p_pos.z / chunk_size))
            );
            
            UtilityFunctions::print(vformat(
                "[ChunkManager] Player Pos: Pos(%.1f, %.1f, %.1f) -> ChunkCoord(%d, %d)", 
                p_pos.x, p_pos.y, p_pos.z, current_chunk_coord.x, current_chunk_coord.y
            ));

            update_chunks_around_player();
            first_update = false;
        }
    } else if (p_node) {
        Vector2i new_coord = Vector2i(
            static_cast<int>(std::floor(p_node->get_global_position().x / chunk_size)),
            static_cast<int>(std::floor(p_node->get_global_position().z / chunk_size))
        );
        if (new_coord != current_chunk_coord) {
            current_chunk_coord = new_coord;
            update_chunks_around_player();
        }
    }
}

void ChunkManager::update_chunks_around_player() {
    HashMap<Vector2i, bool> keep;

    for (int x = -render_distance; x <= render_distance; ++x) {
        for (int z = -render_distance; z <= render_distance; ++z) {
            Vector2i target = current_chunk_coord + Vector2i(x, z);
            keep[target] = true;

            if (!loaded_chunks.has(target) && !pending_tasks.has(target)) {
                UtilityFunctions::print(vformat("[ChunkManager] Requesting load for chunk: X=%d, Z=%d", target.x, target.y));
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

void ChunkManager::load_chunk(const Vector2i &coord) {
    if (loaded_chunks.has(coord) || pending_tasks.has(coord)) return;

    UtilityFunctions::print(vformat("[ChunkManager] Requesting load for chunk: X=%d, Z=%d", coord.x, coord.y));

    ChunkLoadData *data = new ChunkLoadData();
    data->coord = coord;
    data->region_folder_path = region_folder_path;
    data->chunk_size = chunk_size;
    data->manager = this;
    data->is_initial_load = !initial_load_complete;

    int64_t task_id = WorkerThreadPool::get_singleton()->add_native_task(
        &ChunkManager::_async_load_worker,
        data,
        true,
        vformat("Load Chunk (%d, %d)", coord.x, coord.y)
    );

    pending_tasks[coord] = task_id;
}

void ChunkManager::_async_load_worker(void *p_userdata) {
    ChunkLoadData *data = static_cast<ChunkLoadData *>(p_userdata);
    if (!data || !data->manager) return;

    data->categorized_positions = ChunkMeshBuilder::parse_chunk_positions(
        MCAParser::parse_chunk(data->region_folder_path, data->coord.x, data->coord.y)
    );

    data->built_data = ChunkMeshBuilder::build_chunk_data_async(
        data->categorized_positions,
        data->is_initial_load
    );
    data->has_data = true;

    data->manager->call_deferred("_on_chunk_loaded", (uint64_t)data);
}

void ChunkManager::_on_chunk_loaded(Variant p_userdata) {
    uint64_t ptr_val = p_userdata;
    ChunkLoadData *data = reinterpret_cast<ChunkLoadData *>(ptr_val);
    
    if (!data) return;

    pending_tasks.erase(data->coord);

    if (data->has_data) {
        chunk_block_data_map[data->coord] = data->categorized_positions;

        Node3D *chunk_node = memnew(Node3D);
        chunk_node->set_name(vformat("Chunk_%d_%d", data->coord.x, data->coord.y));

        Vector3 pos(
            data->coord.x * data->chunk_size,
            0.0f,
            data->coord.y * data->chunk_size
        );
        chunk_node->set_position(pos);

        ChunkMeshBuilder::apply_chunk_data_to_node(chunk_node, data->built_data);
        add_child(chunk_node);
        loaded_chunks[data->coord] = chunk_node;

        UtilityFunctions::print(vformat("[ChunkManager Main] Chunk (%d, %d) Loaded Successfully", data->coord.x, data->coord.y));
    } else {
        UtilityFunctions::print(vformat("[ChunkManager Main] Chunk (%d, %d) Has No Data", data->coord.x, data->coord.y));
    }

    delete data;

    if (!initial_load_complete && pending_tasks.is_empty()) {
        initial_load_complete = true;
        UtilityFunctions::print("[ChunkManager] ==========================================");
        UtilityFunctions::print("[ChunkManager] Construction of all initial chunks complete. Initiating verification of physical space...");
        UtilityFunctions::print("[ChunkManager] ==========================================");

        call_deferred("verity_initial_collisions");
    }
}

void ChunkManager::verity_initial_collisions() {
    UtilityFunctions::print("[ChunkManager Verification] --- Chunk Hit Detection Verification Log ---");
    
    int total_collision_shapes = 0;
    int total_faces = 0;

    for (const auto &E : loaded_chunks) {
        Node3D *chunk_node = E.value;
        if (!chunk_node) continue;

        for (int i = 0; i < chunk_node->get_child_count(); ++i) {
            StaticBody3D *sb = Object::cast_to<StaticBody3D>(chunk_node->get_child(i));
            if (!sb) continue;

            for (int j = 0; j < sb->get_child_count(); ++j) {
                CollisionShape3D *cs = Object::cast_to<CollisionShape3D>(sb->get_child(j));
                if (!cs) continue;

                total_collision_shapes++;
                Ref<ConcavePolygonShape3D> shape = cs->get_shape();
                if (shape.is_valid()) {
                    PackedVector3Array faces = shape->get_faces();
                    total_faces += faces.size() / 3;
                }
            }
        }
    }

    UtilityFunctions::print(vformat("[ChunkManager Verification] Number of loaded collision shapes: %d", total_collision_shapes));
    UtilityFunctions::print(vformat("[ChunkManager Verification] Total collision polygon count (Triangle Count): %d", total_faces));

    if (total_faces == 0) {
        UtilityFunctions::printerr("[ChunkManager ERROR] There are zero collision polygons! Collision detection has not been generated!");
    } else {
        UtilityFunctions::print("[ChunkManager Verification] SUCCESS: The polygons are correctly registered in the physical space.");
    }
}

void ChunkManager::unload_chunk(const Vector2i &coord) {
    if (!loaded_chunks.has(coord)) return;

    Node3D *chunk_node = loaded_chunks[coord];
    loaded_chunks.erase(coord);

    if (chunk_node) {
        chunk_node->queue_free();
    }
    UtilityFunctions::print(vformat("[ChunkManager] Chunk (%d, %d) Unloaded", coord.x, coord.y));
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