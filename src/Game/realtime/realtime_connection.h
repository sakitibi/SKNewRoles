#pragma once

#include <godot_cpp/classes/ref.hpp>
#include <godot_cpp/classes/web_socket_peer.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class RealtimeConnection : public RefCounted {
        GDCLASS(RealtimeConnection, RefCounted);

        private:
            Ref<WebSocketPeer> _client;
            bool _is_joined_channel;

        protected:
            static void _bind_methods();

        public:
            RealtimeConnection();
            ~RealtimeConnection();

            Error connect_to_url(const String& p_url);
            void poll();
            int64_t get_ready_state() const;

            Ref<WebSocketPeer> get_client() const;
            bool is_joined_channel() const;
            void set_joined_channel(bool joined);

            bool is_ready_to_broadcast() const;
            void send_text(const String& text);

            int64_t get_available_packet_count() const;
            String get_next_packet_string();
            void send_join_channel(const String& topic, const String& p_ref);
    };
}