#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/vector2i.hpp>
#include <godot_cpp/variant/node_path.hpp>

#include "chunk/chunk_loader.h"

namespace godot {
    class ChunkManager : public Node3D {
        GDCLASS(ChunkManager, Node3D)
        private:
            float chunk_size = 16.0f;
            int render_distance = 2;
            bool initial_load_complete = false;
            bool first_update = true;
            NodePath player_path;

            uint64_t player_instance_id = 0;
            Vector2i current_chunk_coord = Vector2i(-999999, -999999);

            HashMap<Vector2i, Node3D *> loaded_chunks;
            HashMap<Vector2i, int64_t> pending_tasks;
            HashMap<Vector2i, HashMap<String, Vector<Vector3>>> chunk_block_data_map;

            String region_folder_path = "res://regions/";

            void update_chunks_around_player();
            void load_chunk(const Vector2i &coord);
            void unload_chunk(const Vector2i &coord);
            Node3D *find_local_player();

        protected:
            static void _bind_methods();

        public:
            ChunkManager();
            ~ChunkManager();

            void _ready() override;
            void _process(double delta) override;

            void _on_chunk_loaded(Variant p_userdata);

            void spawn_falling_block(const Vector3 &spawn_pos, const String &block_type = "stone");
            void _on_block_landed(const Vector3 &land_pos, const String &block_type);

            void verity_initial_collisions();

            void set_chunk_size(float p_size);
            float get_chunk_size() const;
            bool is_initial_load_complete() const;

            void set_render_distance(int p_dist);
            int get_render_distance() const;

            void set_player_path(const NodePath &p_path);
            NodePath get_player_path() const;

            void set_region_folder_path(const String &p_path);
            String get_region_folder_path() const;
    };
}