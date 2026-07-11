#pragma once

#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {
    class ConfigManager : public Node {
        GDCLASS(ConfigManager, Node)

    private:
        String supabase_url;
        String supabase_anon_key;

    protected:
        static void _bind_methods();

    public:
        ConfigManager();
        ~ConfigManager();

        void _ready() override;

        String get_supabase_url() const;
        String get_supabase_key() const;
    };
}