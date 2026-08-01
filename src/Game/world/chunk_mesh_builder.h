#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/classes/concave_polygon_shape3d.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/templates/hash_set.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/packed_vector2_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>
#include <godot_cpp/variant/vector3i.hpp>

namespace godot {
    struct BuiltChunkData {
        HashMap<String, Ref<ArrayMesh>> meshes;
        PackedVector3Array collision_faces;
    };

    // 6方向の定義 (0:Top, 1:Bottom, 2:Back, 3:Front, 4:Right, 5:Left)
    struct CubeFaceData {
        Vector3i dir;
        Vector3 normal;
        Vector3 vertices[4];
        Vector2 uvs[4];
    };

    struct SurfaceMeshData {
        Ref<Material> material;
        PackedVector3Array vertices;
        PackedVector3Array normals;
        PackedVector2Array uvs;
        PackedInt32Array indices;
        int vertex_count = 0;
    };

    class ChunkMeshBuilder : public Object {
        GDCLASS(ChunkMeshBuilder, Object)

        private:
            static int get_palette_index(const PackedInt64Array &data, int palette_size, int x, int y, int z);

        protected:
            static void _bind_methods();

        public:
            ChunkMeshBuilder();
            ~ChunkMeshBuilder();

            static const CubeFaceData CUBE_FACES[6];

            static HashMap<String, Vector<Vector3>> parse_chunk_positions(
                const Dictionary &chunk_data,
                int min_section_y = -4,
                int max_section_y = 19
            );

            static BuiltChunkData build_chunk_data_async(
                const HashMap<String, Vector<Vector3>> &categorized_positions,
                bool p_is_initial_load = false
            );

            static void apply_chunk_data_to_node(Node3D *parent_node, const BuiltChunkData &built_data);
    };
}