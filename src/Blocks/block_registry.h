#pragma once

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class BlockRegistry : public Object {
            GDCLASS(BlockRegistry, Object)

        private:
            static HashMap<String, String> block_scene_map;

        protected:
            static void _bind_methods();

        public:
            BlockRegistry();
            ~BlockRegistry();

            static void register_block(const String &block_id, const String &scene_path);
            static void set_block_scene_map(const Dictionary &p_map);
            static Dictionary get_block_scene_map_dict();
            static void clear_block_map();
            static bool has_block(const String &block_id);

            static const HashMap<String, String>& get_block_scene_map();
    };
}