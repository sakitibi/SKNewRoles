#pragma once

#include <string>
#include <cstdint>

class RealtimePacketBuilder {
    public:
        static std::string build_transform_payload(const std::string& topic, const std::string& player_id, float px, float py, float pz, float rx, float ry, float rz);
        static std::string build_role_payload(const std::string& topic, const std::string& target_player_id, uint32_t role, uint32_t faction);
        static std::string build_hp_payload(const std::string& topic, const std::string& player_id, uint32_t current_hp, uint32_t max_hp);
        static std::string build_hunger_payload(const std::string& topic, const std::string& player_id, uint32_t current_hunger, uint32_t max_hunger);
        static std::string build_hotbar_slot_payload(const std::string& topic, const std::string& player_id, int32_t slot_index);
        static std::string build_hotbar_item_payload(const std::string& topic, const std::string& player_id, int32_t slot_index, const std::string& item_id, uint16_t count);
        static std::string build_attack_payload(const std::string& topic, const std::string& attacker_id, const std::string& target_id, uint32_t damage);
        static std::string build_skin_payload(const std::string& topic, const std::string& player_id);
};