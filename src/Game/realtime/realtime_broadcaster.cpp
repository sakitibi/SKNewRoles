#include "realtime_broadcaster.h"
#include "realtime_packet_builder.h"
#include <godot_cpp/classes/time.hpp>
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/classes/web_socket_peer.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void RealtimeBroadcaster::_bind_methods() {
    ClassDB::bind_method(D_METHOD("send_transform", "connection", "topic", "sender_id", "px", "py", "pz", "rx", "ry", "rz"), &RealtimeBroadcaster::send_transform);
    ClassDB::bind_method(D_METHOD("send_role", "connection", "topic", "target_player_id", "role", "faction"), &RealtimeBroadcaster::send_role);
    ClassDB::bind_method(D_METHOD("send_hp", "connection", "topic", "player_id", "current_hp", "max_hp"), &RealtimeBroadcaster::send_hp);
    ClassDB::bind_method(D_METHOD("send_hunger", "connection", "topic", "player_id", "current_hunger", "max_hunger"), &RealtimeBroadcaster::send_hunger);
    ClassDB::bind_method(D_METHOD("send_hotbar_slot", "connection", "topic", "player_id", "slot_index"), &RealtimeBroadcaster::send_hotbar_slot);
    ClassDB::bind_method(D_METHOD("send_hotbar_item", "connection", "topic", "player_id", "slot_index", "item_id", "count"), &RealtimeBroadcaster::send_hotbar_item);
    ClassDB::bind_method(D_METHOD("send_attack", "connection", "topic", "attacker_id", "target_id", "damage"), &RealtimeBroadcaster::send_attack);
    ClassDB::bind_method(D_METHOD("send_skin", "connection", "topic", "player_id", "skin_presets"), &RealtimeBroadcaster::send_skin);
    ClassDB::bind_method(D_METHOD("send_player_leave", "connection", "topic", "player_id"), &RealtimeBroadcaster::send_player_leave);
}

RealtimeBroadcaster::RealtimeBroadcaster() {
    _last_sent_position = Vector3(0, 0, 0);
    _last_sent_rotation = Vector3(0, 0, 0);
    _last_send_tick = 0;
    _next_ref = 1;
}

bool RealtimeBroadcaster::is_ready(Object* p_connection) {
    if (p_connection == nullptr) return false;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);
    if (connection == nullptr) return false;
    return connection->is_ready_to_broadcast();
}

void RealtimeBroadcaster::send_transform(Object* p_connection, const String& topic, const String& sender_id, float px, float py, float pz, float rx, float ry, float rz) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    uint64_t current_tick = Time::get_singleton()->get_ticks_msec();
    if (current_tick - _last_send_tick < SEND_INTERVAL_MS) {
        return;
    }

    Vector3 current_pos(px, py, pz);
    Vector3 current_rot(rx, ry, rz);

    bool has_moved = current_pos.distance_squared_to(_last_sent_position) > (POS_THRESHOLD * POS_THRESHOLD);
    bool has_rotated = current_rot.distance_squared_to(_last_sent_rotation) > (ROT_THRESHOLD * ROT_THRESHOLD);

    if (!has_moved && !has_rotated) {
        return;
    }

    _last_sent_position = current_pos;
    _last_sent_rotation = current_rot;
    _last_send_tick = current_tick;

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_transform_payload(
        topic.utf8().get_data(), sender_id.utf8().get_data(), px, py, pz, rx, ry, rz, ref_str
    );

    connection->send_text(String(json_str.c_str()));
}

void RealtimeBroadcaster::send_role(Object* p_connection, const String& topic, const String& target_player_id, uint32_t role, uint32_t faction) {
    if (!is_ready(p_connection)) {
        UtilityFunctions::push_error("[RealtimeBroadcaster] Error: Channel join is not completed, cannot send role.");
        return;
    }
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_role_payload(
        topic.utf8().get_data(), target_player_id.utf8().get_data(), role, faction, ref_str
    );

    connection->send_text(String(json_str.c_str()));
    UtilityFunctions::print("[RealtimeBroadcaster] Info: Role data sent successfully for target: ", target_player_id);
}

void RealtimeBroadcaster::send_hp(Object* p_connection, const String& topic, const String& player_id, uint32_t current_hp, uint32_t max_hp) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_hp_payload(
        topic.utf8().get_data(), player_id.utf8().get_data(), current_hp, max_hp, ref_str
    );

    connection->send_text(String(json_str.c_str()));
}

void RealtimeBroadcaster::send_hunger(Object* p_connection, const String& topic, const String& player_id, uint32_t current_hunger, uint32_t max_hunger) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_hunger_payload(
        topic.utf8().get_data(), player_id.utf8().get_data(), current_hunger, max_hunger, ref_str
    );

    connection->send_text(String(json_str.c_str()));
}

void RealtimeBroadcaster::send_hotbar_slot(Object* p_connection, const String& topic, const String& player_id, int32_t slot_index) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_hotbar_slot_payload(
        topic.utf8().get_data(), player_id.utf8().get_data(), slot_index, ref_str
    );

    connection->send_text(String(json_str.c_str()));
}

void RealtimeBroadcaster::send_hotbar_item(Object* p_connection, const String& topic, const String& player_id, int32_t slot_index, const String& item_id, uint16_t count) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_hotbar_item_payload(
        topic.utf8().get_data(), player_id.utf8().get_data(), slot_index, item_id.utf8().get_data(), count, ref_str
    );

    connection->send_text(String(json_str.c_str()));
}

void RealtimeBroadcaster::send_attack(Object* p_connection, const String& topic, const String& attacker_id, const String& target_id, uint32_t damage) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_attack_payload(
        topic.utf8().get_data(), attacker_id.utf8().get_data(), target_id.utf8().get_data(), damage, ref_str
    );

    connection->send_text(String(json_str.c_str()));
}

void RealtimeBroadcaster::send_skin(Object* p_connection, const String& topic, const String& player_id, const Dictionary& skin_presets) {
    int retry_count = 0;
    const int max_retries = 20;

    UtilityFunctions::print("[RealtimeBroadcaster] Info: Waiting for connection readiness to send skin for player: ", player_id);

    while (!is_ready(p_connection) && retry_count < max_retries) {
        UtilityFunctions::print("[RealtimeBroadcaster] Warning: Connection not ready yet, retrying... Attempt: ", retry_count + 1, "/", max_retries);
        OS::get_singleton()->delay_msec(500);
        retry_count++;
    }

    if (!is_ready(p_connection)) {
        UtilityFunctions::push_error("[RealtimeBroadcaster] Error: Failed to send skin because connection is not ready after timeout.");
        return;
    }
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    Ref<JSON> json_instance = memnew(JSON);
    String skin_json_godot = json_instance->stringify(skin_presets);
    std::string skin_json_str = skin_json_godot.utf8().get_data();

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_skin_payload(
        topic.utf8().get_data(), player_id.utf8().get_data(), skin_json_str, ref_str
    );

    connection->send_text(String(json_str.c_str()));
    UtilityFunctions::print("[RealtimeBroadcaster] Info: Skin data sent successfully for player: ", player_id);
}

void RealtimeBroadcaster::send_player_leave(Object* p_connection, const String& topic, const String& player_id) {
    if (!is_ready(p_connection)) return;
    RealtimeConnection* connection = Object::cast_to<RealtimeConnection>(p_connection);

    std::string ref_str = std::to_string(_next_ref++);
    std::string json_str = RealtimePacketBuilder::build_player_leave_payload(
        topic.utf8().get_data(), player_id.utf8().get_data(), ref_str
    );

    connection->send_text(String(json_str.c_str()));
    UtilityFunctions::print("[RealtimeBroadcaster] Info: Player leave broadcast sent for player: ", player_id);
}