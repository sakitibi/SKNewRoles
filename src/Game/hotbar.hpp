#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <array>

namespace godot {
    struct HotbarSlotData {
        int item_id = 0;
        int count = 0;
    };

    class HotbarCpp : public Node {
        GDCLASS(HotbarCpp, Node)

        private:
            std::array<HotbarSlotData, 9> slots_{};
            int selected_index_ = 0;

        protected:
            static void _bind_methods();

        public:
            HotbarCpp();
            ~HotbarCpp();

            void select_slot(int index);
            int get_selected_slot() const;

            void set_slot_item(int index, int item_id, int count);
            Dictionary get_slot_item(int index) const;

            bool consume_item(int index, int amount = 1);
    };
}