#include "lobby_query_service.h"
#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <string>
#include <vector>

using namespace godot;

void LobbyQueryService::_bind_methods() {
    ClassDB::bind_method(D_METHOD("parse_public_lobbies", "json_text"), &LobbyQueryService::parse_public_lobbies);
    ClassDB::bind_method(D_METHOD("parse_lobby_status", "json_text", "room_code", "user_id"), &LobbyQueryService::parse_lobby_status);
}

LobbyQueryService::LobbyQueryService() {}

Array LobbyQueryService::parse_public_lobbies(const String& p_json_text) {
    Array result_list;
    Ref<JSON> json = memnew(JSON);
    Error err = json->parse(p_json_text);
    
    if (err != OK) {
        UtilityFunctions::push_error("[LobbyQueryService] Error: Failed to parse public lobbies JSON.");
        return result_list;
    }

    Variant data = json->get_data();
    if (data.get_type() == Variant::ARRAY) {
        Array arr = data;
        std::vector<LobbyQueryService::NativeLobbyItem> native_lobbies;
        native_lobbies.reserve(arr.size());

        for (int i = 0; i < arr.size(); i++) {
            Variant elem_var = arr[i];
            if (elem_var.get_type() == Variant::DICTIONARY) {
                Dictionary elem = elem_var;
                LobbyQueryService::NativeLobbyItem item;

                if (elem.has("room_code")) {
                    item.room_code = std::string(String(elem["room_code"]).utf8().get_data());
                }
                if (elem.has("room_name")) {
                    item.room_name = std::string(String(elem["room_name"]).utf8().get_data());
                }

                native_lobbies.push_back(item);
            }
        }

        for (const auto& item : native_lobbies) {
            Dictionary lobby_dict;
            lobby_dict["room_code"] = String::utf8(item.room_code.c_str());
            lobby_dict["room_name"] = String::utf8(item.room_name.c_str());
            result_list.push_back(lobby_dict);
        }
    }
    return result_list;
}

Dictionary LobbyQueryService::parse_lobby_status(const String& p_json_text, const String& p_room_code, const String& p_user_id) {
    Dictionary response_dict;
    response_dict["status_code"] = -1;
    response_dict["room_name"] = String("");
    response_dict["is_host"] = false;
    response_dict["is_public"] = true;

    Ref<JSON> json = memnew(JSON);
    Error err = json->parse(p_json_text);

    if (err != OK) {
        UtilityFunctions::push_error("[LobbyQueryService] Error: Failed to parse lobby status JSON.");
        return response_dict;
    }

    Variant data = json->get_data();
    if (data.get_type() == Variant::ARRAY) {
        Array arr = data;
        if (arr.is_empty()) {
            UtilityFunctions::print("[LobbyQueryService] Warning: Lobby not found or blocked by RLS.");
            response_dict["status_code"] = -1;
            return response_dict;
        }

        Variant elem_var = arr[0];
        if (elem_var.get_type() != Variant::DICTIONARY) {
            return response_dict;
        }
        Dictionary lobby_elem = elem_var;

        bool is_active = true;
        if (lobby_elem.has("is_active")) {
            is_active = lobby_elem["is_active"];
        }

        if (!is_active) {
            UtilityFunctions::print("[LobbyQueryService] Warning: Lobby is inactive.");
            response_dict["status_code"] = 1;
            return response_dict;
        }

        std::string room_name = "";
        if (lobby_elem.has("room_name")) {
            room_name = std::string(String(lobby_elem["room_name"]).utf8().get_data());
        }

        std::string host_id = "";
        if (lobby_elem.has("host_id")) {
            host_id = std::string(String(lobby_elem["host_id"]).utf8().get_data());
        }

        bool is_public = true;
        if (lobby_elem.has("is_public")) {
            is_public = lobby_elem["is_public"];
        }

        std::string native_user_id = std::string(p_user_id.utf8().get_data());

        response_dict["status_code"] = 0;
        response_dict["room_name"] = String::utf8(room_name.c_str());
        response_dict["is_host"] = (host_id == native_user_id);
        response_dict["is_public"] = is_public;
    }

    return response_dict;
}