#include "cube_mesh_utils.h"

using namespace godot;

static const char* FACE_NODE_NAMES[6] = {
    "Top", "Bottom", "Front", "Back", "Left", "Right"
};

const char* CubeMeshUtils::get_face_node_name(int index) {
    if (index < 0 || index >= 6) {
        return "";
    }
    return FACE_NODE_NAMES[index];
}

Vector<CubeFaceData> CubeMeshUtils::get_cube_faces_at_y(float pos_y) {
    float y0 = pos_y;
    float y1 = pos_y + 1.0f;

    Vector<CubeFaceData> faces;

    // UVの共通データ
    Vector2 default_uvs[4] = {
        Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)
    };

    {
        CubeFaceData top;
        top.dir = Vector3i(0, 1, 0);
        top.normal = Vector3(0, 1, 0);
        top.vertices[0] = Vector3(0, y1, 0);
        top.vertices[1] = Vector3(1, y1, 0);
        top.vertices[2] = Vector3(1, y1, 1);
        top.vertices[3] = Vector3(0, y1, 1);
        for (int i = 0; i < 4; ++i) top.uvs[i] = default_uvs[i];
        faces.push_back(top);
    }

    {
        CubeFaceData bottom;
        bottom.dir = Vector3i(0, -1, 0);
        bottom.normal = Vector3(0, -1, 0);
        bottom.vertices[0] = Vector3(0, y0, 1);
        bottom.vertices[1] = Vector3(1, y0, 1);
        bottom.vertices[2] = Vector3(1, y0, 0);
        bottom.vertices[3] = Vector3(0, y0, 0);
        for (int i = 0; i < 4; ++i) bottom.uvs[i] = default_uvs[i];
        faces.push_back(bottom);
    }

    {
        CubeFaceData front;
        front.dir = Vector3i(0, 0, 1);
        front.normal = Vector3(0, 0, 1);
        front.vertices[0] = Vector3(0, y1, 1);
        front.vertices[1] = Vector3(1, y1, 1);
        front.vertices[2] = Vector3(1, y0, 1);
        front.vertices[3] = Vector3(0, y0, 1);
        for (int i = 0; i < 4; ++i) front.uvs[i] = default_uvs[i];
        faces.push_back(front);
    }

    {
        CubeFaceData back;
        back.dir = Vector3i(0, 0, -1);
        back.normal = Vector3(0, 0, -1);
        back.vertices[0] = Vector3(1, y1, 0);
        back.vertices[1] = Vector3(0, y1, 0);
        back.vertices[2] = Vector3(0, y0, 0);
        back.vertices[3] = Vector3(1, y0, 0);
        for (int i = 0; i < 4; ++i) back.uvs[i] = default_uvs[i];
        faces.push_back(back);
    }

    {
        CubeFaceData left;
        left.dir = Vector3i(-1, 0, 0);
        left.normal = Vector3(-1, 0, 0);
        left.vertices[0] = Vector3(0, y1, 0);
        left.vertices[1] = Vector3(0, y1, 1);
        left.vertices[2] = Vector3(0, y0, 1);
        left.vertices[3] = Vector3(0, y0, 0);
        for (int i = 0; i < 4; ++i) left.uvs[i] = default_uvs[i];
        faces.push_back(left);
    }

    {
        CubeFaceData right;
        right.dir = Vector3i(1, 0, 0);
        right.normal = Vector3(1, 0, 0);
        right.vertices[0] = Vector3(1, y1, 1);
        right.vertices[1] = Vector3(1, y1, 0);
        right.vertices[2] = Vector3(1, y0, 0);
        right.vertices[3] = Vector3(1, y0, 1);
        for (int i = 0; i < 4; ++i) right.uvs[i] = default_uvs[i];
        faces.push_back(right);
    }

    return faces;
}