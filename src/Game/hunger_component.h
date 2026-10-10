#pragma once

#include <godot_cpp/classes/node.hpp>

namespace godot {
    class HungerComponent : public Node {
        GDCLASS(HungerComponent, Node)

        private:
            int max_hunger = 20;
            int current_hunger = 20;

        protected:
            static void _bind_methods();

        public:
            HungerComponent();
            ~HungerComponent();

            void set_max_hunger(int p_hunger);
            int get_max_hunger() const;

            void set_current_hunger(int p_hunger);
            int get_current_hunger() const;

            void consume_hunger(int amount);
            void restore_hunger(int amount);
    };
}