#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/vector3.hpp>
#include <godot_cpp/variant/string.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include "realtime_connection.h"

namespace godot {
    class RealtimeBroadcaster : public Node {
        GDCLASS(RealtimeBroadcaster, Node);

        private:
            Vector3 _last_sent_position;
            Vector3 _last_sent_rotation;
            uint64_t _last_send_tick;
            static constexpr uint64_t SEND_INTERVAL_MS = 300;
            static constexpr float POS_THRESHOLD = 0.02f;
            static constexpr float ROT_THRESHOLD = 0.02f;

            bool is_ready(Object* p_connection);

        protected:
            static void _bind_methods();

        public:
            RealtimeBroadcaster();
            ~RealtimeBroadcaster() = default;

            void send_transform(Object* p_connection, const String& topic, const String& sender_id, float px, float py, float pz, float rx, float ry, float rz);
            void send_role(Object* p_connection, const String& topic, const String& target_player_id, uint32_t role, uint32_t faction);
            void send_hp(Object* p_connection, const String& topic, const String& player_id, uint32_t current_hp, uint32_t max_hp);
            void send_hunger(Object* p_connection, const String& topic, const String& player_id, uint32_t current_hunger, uint32_t max_hunger);
            void send_hotbar_slot(Object* p_connection, const String& topic, const String& player_id, int32_t slot_index);
            void send_hotbar_item(Object* p_connection, const String& topic, const String& player_id, int32_t slot_index, const String& item_id, uint16_t count);
            void send_attack(Object* p_connection, const String& topic, const String& attacker_id, const String& target_id, uint32_t damage);
            void send_skin(Object* p_connection, const String& topic, const String& player_id, const Dictionary& skin_presets);
    };
}