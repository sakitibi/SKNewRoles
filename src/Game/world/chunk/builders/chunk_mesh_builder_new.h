#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/classes/material.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/packed_vector3_array.hpp>
#include <godot_cpp/variant/packed_vector2_array.hpp>
#include <godot_cpp/variant/packed_int32_array.hpp>

namespace godot {
    struct BuiltChunkDataNew {
        HashMap<String, Ref<ArrayMesh>> meshes;
        PackedVector3Array collision_faces;
    };

    struct SurfaceMeshDataNew {
        Ref<Material> material;
        PackedVector3Array vertices;
        PackedVector3Array normals;
        PackedVector2Array uvs;
        PackedInt32Array indices;
        int vertex_count = 0;
    };

    class ChunkMeshBuilderNew : public Object {
        GDCLASS(ChunkMeshBuilderNew, Object)

        protected:
            static void _bind_methods() {}

        public:
            ChunkMeshBuilderNew() {}
            ~ChunkMeshBuilderNew() {}

            static BuiltChunkDataNew build_chunk_data_async(
                const HashMap<String, Vector<Vector3>> &categorized_positions,
                bool p_is_initial_load = false
            );
    };
}