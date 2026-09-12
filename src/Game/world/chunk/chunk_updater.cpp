#include "chunk_updater.h"
#include "chunk_manager.h"

#include <godot_cpp/classes/worker_thread_pool.hpp>
#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <cmath>

using namespace godot;

void ChunkUpdater::update_chunks_around_player(ChunkManager *manager, const Vector3 &center_pos) {
    if (!manager) return;

    float chunk_size = manager->get_chunk_size();
    int render_distance = manager->get_render_distance();

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

    auto &loaded_chunks = manager->get_loaded_chunks();
    auto &pending_tasks = manager->get_pending_tasks();

    Vector<Vector2i> chunks_to_unload;
    for (const KeyValue<Vector2i, Node3D *> &E : loaded_chunks) {
        if (!required_chunks.has(E.key)) {
            chunks_to_unload.push_back(E.key);
        }
    }

    for (int i = 0; i < chunks_to_unload.size(); ++i) {
        manager->unload_chunk(chunks_to_unload[i]);
    }

    int requested = 0;
    for (const Vector2i &coord : required_chunks) {
        if (!loaded_chunks.has(coord) && !pending_tasks.has(coord)) {
            load_chunk(manager, coord);
            requested++;
        }
    }

    UtilityFunctions::print(vformat("[ChunkManager] Chunk update status: requested=%d / pending=%d / loaded=%d", 
        requested, pending_tasks.size(), loaded_chunks.size()));

    if (!manager->is_initial_load_complete() && pending_tasks.is_empty()) {
        manager->set_initial_load_complete(true);
        manager->call_deferred("verity_initial_collisions");
        UtilityFunctions::print("[ChunkManager] Initial chunk loading completed.");
    }
}

void ChunkUpdater::load_chunk(ChunkManager *manager, const Vector2i &coord) {
    if (!manager) return;

    auto &loaded_chunks = manager->get_loaded_chunks();
    auto &pending_tasks = manager->get_pending_tasks();

    if (loaded_chunks.has(coord) || pending_tasks.has(coord)) return;

    UtilityFunctions::print(vformat("[ChunkManager] Queueing chunk task for coord: (%d, %d)", coord.x, coord.y));

    ChunkLoadData *load_data = new ChunkLoadData();
    load_data->coord = coord;
    load_data->chunk_size = manager->get_chunk_size();
    load_data->chunk_height = manager->get_chunk_height();
    load_data->base_y_position = manager->get_base_y_position();
    load_data->min_height = manager->get_min_height();
    load_data->max_height = manager->get_max_height();
    load_data->region_folder_path = manager->get_region_folder_path();
    load_data->is_initial_load = !manager->is_initial_load_complete();

    uint64_t ptr_val = reinterpret_cast<uint64_t>(load_data);

    int64_t task_id = WorkerThreadPool::get_singleton()->add_task(
        Callable(manager, "_async_load_task").bind(ptr_val),
        true
    );

    pending_tasks[coord] = task_id;
}