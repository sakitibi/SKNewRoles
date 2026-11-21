#pragma once

#include <godot_cpp/classes/ref_counted.hpp>

namespace godot {
    class ConfigManager : public RefCounted {
        GDCLASS(ConfigManager, RefCounted)

        private:
            String supabase_url;
            String supabase_anon_key;

        protected:
            static void _bind_methods();

        public:
            ConfigManager();
            ~ConfigManager();

            String get_supabase_url() const;
            String get_supabase_key() const;
    };
}