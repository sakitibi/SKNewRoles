#pragma once

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/dictionary.hpp>

namespace godot {
    class LobbyManager : public Node2D {
        GDCLASS(LobbyManager, Node2D);
        private:
            Ref<PackedScene> other_player_prefab;
            HashMap<String, Node2D*> other_players;
            HashMap<String, Dictionary> remote_player_skins;
            Node2D* my_player = nullptr;

        protected:
            static void _bind_methods();

        public:
            LobbyManager();
            ~LobbyManager();

            void _ready() override;
            
            // インスペクター用のプロパティ
            void set_other_player_prefab(const Ref<PackedScene> &p_prefab);
            Ref<PackedScene> get_other_player_prefab() const;

            void update_other_player_position(const String &player_id, float x, float y);

            void update_remote_player_skin(const String &player_id, const Dictionary &skin_presets);
    };
}