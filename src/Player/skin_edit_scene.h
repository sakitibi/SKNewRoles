#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/button.hpp>
#include <godot_cpp/classes/input_event.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {
    class SkinEditScene : public Node3D {
        GDCLASS(SkinEditScene, Node3D)

    private:
        Button *back_button = nullptr;
        Button *save_button = nullptr;
        Node3D *skin_model_container = nullptr;

        Array available_presets;
        Dictionary equipped_presets;

        const String dummy_scene_path = "res://Scenes/Prefabs/LobbyPlayerDummy.tscn";
        const String lobby_select_scene_path = "res://Scenes/LobbySelect.tscn";

        bool is_dragging = false;
        float rotate_sensitivity = 0.005f;

        void on_back_button_pressed();
        void on_save_button_pressed();
        void cycle_part_preset(const String &part_name);
        void apply_part_preset(const String &part_name, const String &preset_id);
        void load_player_preview();

        void _on_head_button_pressed();
        void _on_body_button_pressed();
        void _on_right_arm_button_pressed();
        void _on_left_arm_button_pressed();
        void _on_right_leg_button_pressed();
        void _on_left_leg_button_pressed();

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