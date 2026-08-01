#pragma once

#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/vector2.hpp>
#include <godot_cpp/variant/vector3i.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/templates/vector.hpp>

namespace godot {

    struct CubeFaceData {
        Vector3i dir;
        Vector3 normal;
        Vector3 vertices[4];
        Vector2 uvs[4];
    };

    class CubeMeshUtils {
    public:
        static Vector<CubeFaceData> get_cube_faces(float height = 1.0f);

        static const char* get_face_node_name(int index);
    };

}