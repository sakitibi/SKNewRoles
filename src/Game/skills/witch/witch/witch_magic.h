#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class WitchMagic : public Node {
        GDCLASS(WitchMagic, Node)

    private:
        Node* scene = nullptr;
        Object* player_combat_sync_handler = nullptr;

        String get_target_player_id(Node* user);
        void apply_damage_to_target(const String& target_player_id, uint16_t damage_amount);

        inline uint16_t calculate_native_damage(uint16_t base_damage, float multiplier = 1.0f) const {
            return static_cast<uint16_t>(base_damage * multiplier);
        }

        inline bool validate_skill_parameters(Node* user, double delay) const {
            return user != nullptr && delay > 0.0;
        }

    protected:
        static void _bind_methods();

    public:
        WitchMagic();
        ~WitchMagic();

        void _exit_tree() override;

        void initialize(Node* p_scene, Object* p_sync_handler);
        void use_skill(Node* user);
        void _on_timer_timeout(Node* user, String target_player_id, uint16_t damage_amount);
    };
}