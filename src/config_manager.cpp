#include "config_manager.h"
#include <godot_cpp/classes/os.hpp>
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

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

ConfigManager::ConfigManager() {}
ConfigManager::~ConfigManager() {}

void ConfigManager::_ready() {
    // 1. まずコンパイル時定数（CMake等のマクロ）から初期設定
    supabase_url = DEFAULT_SUPABASE_URL;
    supabase_anon_key = DEFAULT_SUPABASE_ANON_KEY;

    // 2. Godot の ProjectSettings から取得（設定されている場合）
    ProjectSettings *ps = ProjectSettings::get_singleton();
    if (ps != nullptr) {
        if (supabase_url.is_empty() && ps->has_setting("global/supabase_url")) {
            supabase_url = ps->get_setting("global/supabase_url");
        }
        if (supabase_anon_key.is_empty() && ps->has_setting("global/supabase_anon_key")) {
            supabase_anon_key = ps->get_setting("global/supabase_anon_key");
        }
    }

    // 3. OSの環境変数があれば最優先で上書き（ローカルテストや特定環境用）
    OS *os = OS::get_singleton();
    if (os != nullptr) {
        String env_url = os->get_environment("SUPABASE_URL");
        if (!env_url.is_empty()) {
            supabase_url = env_url;
        }

        String env_key = os->get_environment("SUPABASE_ANON_KEY");
        if (!env_key.is_empty()) {
            supabase_anon_key = env_key;
        }
    }

    // 警告メッセージの出力（値が取得できなかった場合）
    if (supabase_url.is_empty()) {
        UtilityFunctions::printerr("⚠️ [ConfigManager] SUPABASE_URL が設定されていません。");
    }
    if (supabase_anon_key.is_empty()) {
        UtilityFunctions::printerr("⚠️ [ConfigManager] SUPABASE_ANON_KEY が設定されていません。");
    }
}

String ConfigManager::get_supabase_url() const {
    return supabase_url;
}

String ConfigManager::get_supabase_key() const {
    return supabase_anon_key;
}