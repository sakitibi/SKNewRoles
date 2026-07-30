#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {
    class HealthComponent : public Node {
        GDCLASS(HealthComponent, Node)
        private:
            int max_hp = 20;
            int current_hp = 20;
            bool is_dead = false;

        protected:
            static void _bind_methods();

        public:
            HealthComponent();
            ~HealthComponent();

            void set_max_hp(int p_max_hp);
            int get_max_hp() const;

            void set_current_hp(int p_hp);
            int get_current_hp() const;

            bool get_is_dead() const { return is_dead; }

            // HP操作メソッド
            void take_damage(int p_amount);
            void heal(int p_amount);
            void die();
            void respawn(int p_health_percentage = 100);
    };
}