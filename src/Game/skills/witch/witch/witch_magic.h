#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {
    class WitchMagic : public Node {
        GDCLASS(WitchMagic, Node)

        private:
            Node* scene = nullptr;
            Object* player_combat_sync_handler = nullptr;

            String get_target_player_id(Node* user);
            void apply_damage_to_target(const String& target_player_id, uint16_t damage_amount);

        protected:
            static void _bind_methods();

        public:
            WitchMagic() = default;
            ~WitchMagic() override = default;

            void initialize(Node* p_scene, Object* p_sync_handler);
            void use_skill(Node* user);

            void _on_timer_timeout(Node* user, String target_player_id, uint16_t damage_amount);
    };

}