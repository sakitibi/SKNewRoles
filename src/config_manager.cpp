#include "config_manager.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

// コンパイル時にマクロが定義されていなければ空文字にする
#ifndef DEFAULT_SUPABASE_URL
#define DEFAULT_SUPABASE_URL ""
#endif

#ifndef DEFAULT_SUPABASE_ANON_KEY
#define DEFAULT_SUPABASE_ANON_KEY ""
#endif

void ConfigManager::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_supabase_url"), &ConfigManager::get_supabase_url);
    ClassDB::bind_method(D_METHOD("get_supabase_key"), &ConfigManager::get_supabase_key);
}

ConfigManager::ConfigManager() {
    supabase_url = String(DEFAULT_SUPABASE_URL);
    supabase_anon_key = String(DEFAULT_SUPABASE_ANON_KEY);
}

ConfigManager::~ConfigManager() {}

void ConfigManager::_ready() {
    if (supabase_url.is_empty()) {
        UtilityFunctions::printerr("⚠️ [ConfigManager] DEFAULT_SUPABASE_URL が空です。");
    } else {
        UtilityFunctions::print("[ConfigManager] SUPABASE_URL を正常にロードしました: ", supabase_url);
    }

    if (supabase_anon_key.is_empty()) {
        UtilityFunctions::printerr("⚠️ [ConfigManager] DEFAULT_SUPABASE_ANON_KEY が空です。");
    }
}

String ConfigManager::get_supabase_url() const {
    return supabase_url;
}

String ConfigManager::get_supabase_key() const {
    return supabase_anon_key;
}