#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    // 陣営（Faction）の定義
    enum Faction {
        CITIZEN_FACTION = 0, // 村人陣営
        WEREWOLF_FACTION = 1, // 人狼陣営
        NEUTRAL_FACTION = 2  // 第三陣営
    };

    // 役職（Role）の定義
    enum Role {
        CITIZEN = 0,    // 村人
        WEREWOLF = 1,   // 人狼
    };

    class RoleManager : public Node {
        GDCLASS(RoleManager, Node);

        protected:
            static void _bind_methods();

        public:
            RoleManager();
            ~RoleManager();

            Dictionary assign_roles(Array player_ids, Dictionary role_counts);
    };
}