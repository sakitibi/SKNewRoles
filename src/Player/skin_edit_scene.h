#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/button.hpp>
#include <godot_cpp/classes/input_event.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/string.hpp>
#include "skin_edit_logic.h"

namespace godot {
    class SkinEditScene : public Node3D {
        GDCLASS(SkinEditScene, Node3D)

        private:
            Button *back_button = nullptr;
            Button *save_button = nullptr;
            Node3D *skin_model_container = nullptr;

            SkinEditLogic logic;

            const String dummy_scene_path = "res://Scenes/Prefabs/LobbyPlayerDummy.tscn";
            const String lobby_select_scene_path = "res://Scenes/LobbySelect.tscn";

            bool is_dragging = false;

            void on_back_button_pressed();
            void on_save_button_pressed();
            void handle_part_cycle(const String &part_name);
            void apply_part_preset_to_painter(const String &part_name, const String &preset_id);
            void load_player_preview();

            void _on_head_button_pressed();
            void _on_body_button_pressed();
            void _on_right_arm_button_pressed();
            void _on_left_arm_button_pressed();
            void _on_right_leg_button_pressed();
            void _on_left_leg_button_pressed();

            Dictionary convert_cpp_map_to_dictionary(const std::map<std::string, std::string> &map) const;
            std::map<std::string, std::string> convert_dictionary_to_cpp_map(const Dictionary &dict) const;

        protected:
            static void _bind_methods();

        public:
            SkinEditScene();
            ~SkinEditScene();

            void _ready() override;
            void _unhandled_input(const Ref<InputEvent> &event) override;

            void select_preset_for_all(const String &preset_id);

            Dictionary get_equipped_presets() const;
            void set_equipped_presets(const Dictionary &p_presets);

            void set_rotate_sensitivity(float p_val);
            float get_rotate_sensitivity() const;
        };
}