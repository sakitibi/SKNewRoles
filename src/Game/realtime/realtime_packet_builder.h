#pragma once

#include <string>
#include <cstdint>

class RealtimePacketBuilder {
    public:
        static std::string build_transform_payload(const std::string& topic, const std::string& player_id, float px, float py, float pz, float rx, float ry, float rz, const std::string& p_ref);
        static std::string build_role_payload(const std::string& topic, const std::string& target_player_id, uint32_t role, uint32_t faction, const std::string& p_ref);
        static std::string build_hp_payload(const std::string& topic, const std::string& player_id, uint32_t current_hp, uint32_t max_hp, const std::string& p_ref);
        static std::string build_hunger_payload(const std::string& topic, const std::string& player_id, uint32_t current_hunger, uint32_t max_hunger, const std::string& p_ref);
        static std::string build_hotbar_slot_payload(const std::string& topic, const std::string& player_id, int32_t slot_index, const std::string& p_ref);
        static std::string build_hotbar_item_payload(const std::string& topic, const std::string& player_id, int32_t slot_index, const std::string& item_id, uint16_t count, const std::string& p_ref);
        static std::string build_attack_payload(const std::string& topic, const std::string& attacker_id, const std::string& target_id, uint32_t damage, const std::string& p_ref);
        static std::string build_player_leave_payload(const std::string& topic, const std::string& player_id, const std::string& p_ref);
        static std::string build_join_payload(const std::string& topic, const std::string& p_ref = "1");
        static std::string build_skin_payload(const std::string& topic, const std::string& player_id, const std::string& skin_json_str, const std::string& p_ref);
};