#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/vector2i.hpp>

namespace godot {

class ChunkManager : public Node3D {
    GDCLASS(ChunkManager, Node3D)

private:
    float chunk_size = 16.0f;
    int render_distance = 2;
    bool first_update = true;
    NodePath player_path;

    Node3D *player_node = nullptr;
    Vector2i current_chunk_coord = Vector2i(-999999, -999999);

    HashMap<Vector2i, Node3D *> loaded_chunks;

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

    // Getter / Setter
    void set_chunk_size(float p_size);
    float get_chunk_size() const;

    void set_render_distance(int p_dist);
    int get_render_distance() const;

    void set_player_path(const NodePath &p_path);
    NodePath get_player_path() const;
};

} // namespace godot