#include "config_manager.h"

using namespace godot;

void ConfigManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_supabase_url"), &ConfigManager::get_supabase_url);
    ClassDB::bind_method(D_METHOD("get_supabase_key"), &ConfigManager::get_supabase_key);
}

ConfigManager::ConfigManager() {}
ConfigManager::~ConfigManager() {}

String ConfigManager::get_supabase_url() const {
    return supabase_url;
}

String ConfigManager::get_supabase_key() const {
    return supabase_anon_key;
}