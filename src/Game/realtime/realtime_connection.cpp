#include "realtime_connection.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/json.hpp>

using namespace godot;

void RealtimeConnection::_bind_methods() {
    ClassDB::bind_method(D_METHOD("connect_to_url", "url"), &RealtimeConnection::connect_to_url);
    ClassDB::bind_method(D_METHOD("poll"), &RealtimeConnection::poll);
    ClassDB::bind_method(D_METHOD("get_ready_state"), &RealtimeConnection::get_ready_state);
    ClassDB::bind_method(D_METHOD("get_client"), &RealtimeConnection::get_client);
    ClassDB::bind_method(D_METHOD("is_joined_channel"), &RealtimeConnection::is_joined_channel);
    ClassDB::bind_method(D_METHOD("set_joined_channel", "joined"), &RealtimeConnection::set_joined_channel);
    ClassDB::bind_method(D_METHOD("is_ready_to_broadcast"), &RealtimeConnection::is_ready_to_broadcast);
    ClassDB::bind_method(D_METHOD("send_text", "text"), &RealtimeConnection::send_text);
    ClassDB::bind_method(D_METHOD("get_available_packet_count"), &RealtimeConnection::get_available_packet_count);
    ClassDB::bind_method(D_METHOD("get_next_packet_string"), &RealtimeConnection::get_next_packet_string);
    ClassDB::bind_method(D_METHOD("send_join_channel", "topic", "ref"), &RealtimeConnection::send_join_channel);
}

RealtimeConnection::RealtimeConnection() {
    _client.instantiate();
    _is_joined_channel = false;
}

RealtimeConnection::~RealtimeConnection() {
    if (_client.is_valid() && _client->get_ready_state() == WebSocketPeer::STATE_OPEN) {
        _client->close(1000, "Connection disposed");
    }
}

Error RealtimeConnection::connect_to_url(const String& p_url) {
    if (_client.is_null()) {
        _client.instantiate();
    }
    _is_joined_channel = false;
    return _client->connect_to_url(p_url);
}

void RealtimeConnection::poll() {
    if (_client.is_valid()) {
        _client->poll();
    }
}

int64_t RealtimeConnection::get_ready_state() const {
    if (_client.is_null()) {
        return (int64_t)WebSocketPeer::STATE_CLOSED;
    }
    return (int64_t)_client->get_ready_state();
}

Ref<WebSocketPeer> RealtimeConnection::get_client() const {
    return _client;
}

bool RealtimeConnection::is_joined_channel() const {
    return _is_joined_channel;
}

void RealtimeConnection::set_joined_channel(bool joined) {
    _is_joined_channel = joined;
}

bool RealtimeConnection::is_ready_to_broadcast() const {
    if (_client.is_null()) return false;
    return _client->get_ready_state() == WebSocketPeer::STATE_OPEN && _is_joined_channel;
}

void RealtimeConnection::send_text(const String& text) {
    if (_client.is_valid() && _client->get_ready_state() == WebSocketPeer::STATE_OPEN) {
        Error err = _client->send_text(text);
        if (err != OK) {
            UtilityFunctions::push_error("[RealtimeConnection] Failed to send text, error: ", err);
        }
    } else {
        UtilityFunctions::push_error("[RealtimeConnection] Cannot send text because WebSocket is not open.");
    }
}

int64_t RealtimeConnection::get_available_packet_count() const {
    if (_client.is_valid() && _client->get_ready_state() == WebSocketPeer::STATE_OPEN) {
        return _client->get_available_packet_count();
    }
    return 0;
}

String RealtimeConnection::get_next_packet_string() {
    if (_client.is_valid() && _client->get_ready_state() == WebSocketPeer::STATE_OPEN) {
        if (_client->get_available_packet_count() > 0) {
            PackedByteArray packet = _client->get_packet();
            if (packet.size() > 0) {
                return String::utf8((const char*)packet.ptr(), packet.size());
            }
        }
    }
    return String();
}

void RealtimeConnection::send_join_channel(const String& topic, const String& p_ref) {
    if (_client.is_null() || _client->get_ready_state() != WebSocketPeer::STATE_OPEN) {
        return;
    }

    Dictionary broadcast_config;
    broadcast_config["self"] = false;

    Dictionary payload_config;
    payload_config["broadcast"] = broadcast_config;

    Dictionary join_payload;
    join_payload["topic"] = topic;
    join_payload["event"] = "phx_join";
    join_payload["payload"] = payload_config;
    join_payload["ref"] = p_ref;

    String json_str = JSON::stringify(join_payload);
    _client->send_text(json_str);
    UtilityFunctions::print("📡 [RealtimeConnection] phx_join リクエストをC++側から送信しました: ", topic);
}