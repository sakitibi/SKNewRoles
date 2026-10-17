#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/string.hpp>
#include <cstdint>

namespace godot {
    namespace DefaultRoles {
        const uint32_t STUDENTS = 0;
        const uint32_t WEREWOLF = 1;
    }

    namespace DefaultFactions {
        const uint32_t STUDENTS_FACTION = 0;
        const uint32_t WEREWOLF_FACTION = 1;
        const uint32_t NEUTRAL_FACTION = 2;
    }

    class RoleManager : public Node {
        GDCLASS(RoleManager, Node);

        protected:
            static void _bind_methods();

        public:
            RoleManager();
            ~RoleManager();

            Dictionary assign_roles(Array player_ids, Dictionary role_counts, Dictionary role_factions = Dictionary());
    };
}