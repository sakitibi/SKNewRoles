#pragma once

#include <godot_cpp/classes/ref.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <string>
#include <vector>

namespace godot {
    class LobbyQueryService : public RefCounted {
        GDCLASS(LobbyQueryService, RefCounted);

        private:
            struct NativeLobbyItem {
                std::string room_code;
                std::string room_name;
            };

        protected:
            static void _bind_methods();

        public:
            LobbyQueryService();
            ~LobbyQueryService() = default;

            Array parse_public_lobbies(const String& p_json_text);
            Dictionary parse_lobby_status(const String& p_json_text, const String& p_room_code, const String& p_user_id);
    };
}