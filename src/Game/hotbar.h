#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <array>

namespace godot {
    struct HotbarSlotData {
        int item_id = 0;
        int count = 0;
    };

    class Hotbar : public Node {
        GDCLASS(Hotbar, Node)

        private:
            std::array<HotbarSlotData, 9> slots_{};
            int selected_index_ = 0;

        protected:
            static void _bind_methods();

        public:
            Hotbar();
            ~Hotbar();

            void select_slot(int index);
            int get_selected_slot() const;

            void set_slot_item(int index, int item_id, int count);
            Dictionary get_slot_item(int index) const;

            bool add_item(int item_id, int count = 1);
            bool consume_item(int index, int amount = 1);
    };
}