#include "realtime_packet_builder.h"
#include <sstream>

std::string RealtimePacketBuilder::build_transform_payload(const std::string& topic, const std::string& player_id, float px, float py, float pz, float rx, float ry, float rz, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;
    
    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"transform_all\","
       << "\"player_id\":\"" << player_id << "\","
       << "\"px\":" << px << ",\"py\":" << py << ",\"pz\":" << pz << ","
       << "\"rx\":" << rx << ",\"ry\":" << ry << ",\"rz\":" << rz
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_role_payload(const std::string& topic, const std::string& target_player_id, uint32_t role, uint32_t faction, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"assign_role\","
       << "\"target_player_id\":\"" << target_player_id << "\","
       << "\"role\":" << role << ","
       << "\"faction\":" << faction
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_hp_payload(const std::string& topic, const std::string& player_id, uint32_t current_hp, uint32_t max_hp, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"player_hp\","
       << "\"player_id\":\"" << player_id << "\","
       << "\"current_hp\":" << current_hp << ","
       << "\"max_hp\":" << max_hp
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_hunger_payload(const std::string& topic, const std::string& player_id, uint32_t current_hunger, uint32_t max_hunger, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"player_hunger\","
       << "\"player_id\":\"" << player_id << "\","
       << "\"current_hunger\":" << current_hunger << ","
       << "\"max_hunger\":" << max_hunger
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_hotbar_slot_payload(const std::string& topic, const std::string& player_id, int32_t slot_index, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"hotbar_slot\","
       << "\"player_id\":\"" << player_id << "\","
       << "\"slot_index\":" << slot_index
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_hotbar_item_payload(const std::string& topic, const std::string& player_id, int32_t slot_index, const std::string& item_id, uint16_t count, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"hotbar_item\","
       << "\"player_id\":\"" << player_id << "\","
       << "\"slot_index\":" << slot_index << ","
       << "\"item_id\":\"" << item_id << "\","
       << "\"count\":" << count
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_attack_payload(const std::string& topic, const std::string& attacker_id, const std::string& target_id, uint32_t damage, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"player_attack\","
       << "\"attacker_id\":\"" << attacker_id << "\","
       << "\"target_id\":\"" << target_id << "\","
       << "\"damage\":" << damage
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_player_leave_payload(const std::string& topic, const std::string& player_id, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"player_leave\","
       << "\"player_id\":\"" << player_id << "\""
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}

std::string RealtimePacketBuilder::build_join_payload(const std::string& topic, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"phx_join\","
       << "\"payload\":{"
       << "\"config\":{"
       << "\"broadcast\":{\"self\":false}"
       << "}"
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
       
    return ss.str();
}

std::string RealtimePacketBuilder::build_skin_payload(const std::string& topic, const std::string& player_id, const std::string& skin_json_str, const std::string& p_ref) {
    std::ostringstream ss;
    std::string safe_topic = topic.empty() ? "realtime:public:lobbies" : topic;
    std::string ref_str = p_ref.empty() ? "1" : p_ref;

    ss << "{"
       << "\"topic\":\"" << safe_topic << "\","
       << "\"event\":\"broadcast\","
       << "\"payload\":{"
       << "\"type\":\"player_skin\","
       << "\"player_id\":\"" << player_id << "\","
       << "\"skins\":" << skin_json_str
       << "},"
       << "\"ref\":\"" << ref_str << "\""
       << "}";
    return ss.str();
}