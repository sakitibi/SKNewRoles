#include "chunk_veritier.h"
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void ChunkVeritier::verity_initial_collisions(const HashMap<Vector2i, Node3D *> &loaded_chunks) {
    UtilityFunctions::print("[ChunkManager Veritication] --- Chunk Hit Detection Veritication Log ---");

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

    UtilityFunctions::print(vformat("[ChunkManager Veritication] Number of loaded collision shapes: %d", total_collision_shapes));
    UtilityFunctions::print(vformat("[ChunkManager Veritication] Total collision polygon count (Triangle Count): %d", total_faces));

    if (total_faces == 0) {
        UtilityFunctions::printerr("[ChunkManager ERROR] There are zero collision polygons! Collision detection has not been generated!");
    } else {
        UtilityFunctions::print("[ChunkManager Veritication] SUCCESS: The polygons are correctly registered in the physical space.");
    }
}