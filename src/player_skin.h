#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class PlayerSkin {
        public:
            static void apply_custom_skins(Node3D *player_node);
            static void apply_part_skin(Node3D *player_node, const String &node_path, const String &file_name);
    };
}