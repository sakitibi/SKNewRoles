#include "chunk_node_applier.h"
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>

using namespace godot;

void ChunkNodeApplier::apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkDataNew &built_data) {
    if (!parent_node) return;

    for (const auto &E : built_data.meshes) {
        MeshInstance3D *mi = memnew(MeshInstance3D);
        mi->set_mesh(E.value);
        parent_node->add_child(mi);
    }

    if (built_data.collision_faces.size() > 0) {
        StaticBody3D *static_body = memnew(StaticBody3D);
        static_body->set_name("ChunkStaticBody");

        CollisionShape3D *collision_shape = memnew(CollisionShape3D);
        Ref<ConcavePolygonShape3D> concave_shape;
        concave_shape.instantiate();
        concave_shape->set_faces(built_data.collision_faces);

        collision_shape->set_shape(concave_shape);
        static_body->add_child(collision_shape);

        parent_node->add_child(static_body);
    }
}