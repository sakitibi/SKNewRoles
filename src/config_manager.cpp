#include "config_manager.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

#define STRINGIFY_DETAIL(x) #x
#define STRINGIFY(x) STRINGIFY_DETAIL(x)

#ifdef DEFAULT_SUPABASE_URL
const char* raw_supabase_url = DEFAULT_SUPABASE_URL;
#else
const char* raw_supabase_url = "";
#endif

#ifdef DEFAULT_SUPABASE_ANON_KEY
const char* raw_supabase_key = DEFAULT_SUPABASE_ANON_KEY;
#else
const char* raw_supabase_key = "";
#endif

void ConfigManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_supabase_url"), &ConfigManager::get_supabase_url);
    ClassDB::bind_method(D_METHOD("get_supabase_key"), &ConfigManager::get_supabase_key);
}

ConfigManager::ConfigManager() {}
ConfigManager::~ConfigManager() {}

void ConfigManager::_ready() {
    supabase_url = String(raw_supabase_url);
    supabase_anon_key = String(raw_supabase_key);

    if (supabase_url.is_empty()) {
        UtilityFunctions::printerr("⚠️ [ConfigManager] ビルド時定数 (DEFAULT_SUPABASE_URL) が空です。");
    } else {
        UtilityFunctions::print("[ConfigManager] SUPABASE_URL を正常にロードしました。");
    }

    if (supabase_anon_key.is_empty()) {
        UtilityFunctions::printerr("⚠️ [ConfigManager] ビルド時定数 (DEFAULT_SUPABASE_ANON_KEY) が空です。");
    }
}

String ConfigManager::get_supabase_url() const {
    return supabase_url;
}

String ConfigManager::get_supabase_key() const {
    return supabase_anon_key;
}