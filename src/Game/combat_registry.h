#pragma once

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <string>
#include <unordered_map>

namespace godot {
    class CombatRegistry : public Object {
        GDCLASS(CombatRegistry, Object)

        private:
            std::unordered_map<std::string, uint32_t> weapon_damages_;
            static CombatRegistry *singleton_;

        protected:
            static void _bind_methods();

        public:
            CombatRegistry();
            ~CombatRegistry();

            static CombatRegistry *get_singleton();

            void register_weapon_damage(const String &item_id, uint32_t damage);
            uint32_t get_weapon_damage(const String &item_id) const;
    };
}