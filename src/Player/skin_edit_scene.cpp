#include "skin_edit_scene.h"
#include "skin_painter.h"
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/input_event_mouse_button.hpp>
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/config_file.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

SkinEditScene::SkinEditScene() {}
SkinEditScene::~SkinEditScene() {}

void SkinEditScene::_bind_methods() {
    ClassDB::bind_method(D_METHOD("select_preset_for_all", "preset_id"), &SkinEditScene::select_preset_for_all);
    
    ClassDB::bind_method(D_METHOD("get_equipped_presets"), &SkinEditScene::get_equipped_presets);
    ClassDB::bind_method(D_METHOD("set_equipped_presets", "p_presets"), &SkinEditScene::set_equipped_presets);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "equipped_presets"), "set_equipped_presets", "get_equipped_presets");

    ClassDB::bind_method(D_METHOD("set_rotate_sensitivity", "p_val"), &SkinEditScene::set_rotate_sensitivity);
    ClassDB::bind_method(D_METHOD("get_rotate_sensitivity"), &SkinEditScene::get_rotate_sensitivity);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "rotate_sensitivity"), "set_rotate_sensitivity", "get_rotate_sensitivity");

    ClassDB::bind_method(D_METHOD("on_back_button_pressed"), &SkinEditScene::on_back_button_pressed);
    ClassDB::bind_method(D_METHOD("on_save_button_pressed"), &SkinEditScene::on_save_button_pressed);
    
    ClassDB::bind_method(D_METHOD("_on_head_button_pressed"), &SkinEditScene::_on_head_button_pressed);
    ClassDB::bind_method(D_METHOD("_on_body_button_pressed"), &SkinEditScene::_on_body_button_pressed);
    ClassDB::bind_method(D_METHOD("_on_right_arm_button_pressed"), &SkinEditScene::_on_right_arm_button_pressed);
    ClassDB::bind_method(D_METHOD("_on_left_arm_button_pressed"), &SkinEditScene::_on_left_arm_button_pressed);
    ClassDB::bind_method(D_METHOD("_on_right_leg_button_pressed"), &SkinEditScene::_on_right_leg_button_pressed);
    ClassDB::bind_method(D_METHOD("_on_left_leg_button_pressed"), &SkinEditScene::_on_left_leg_button_pressed);
}

void SkinEditScene::_ready() {
    String ui_path = "CanvasLayer/Control/MarginContainer/VBoxContainer/";
    
    back_button = Object::cast_to<Button>(get_node_or_null(ui_path + "BackButton"));
    save_button = Object::cast_to<Button>(get_node_or_null(ui_path + "SaveButton"));
    skin_model_container = Object::cast_to<Node3D>(get_node_or_null("SkinModelContainer"));

    if (back_button) {
        back_button->connect("pressed", Callable(this, "on_back_button_pressed"));
    }
    if (save_button) {
        save_button->connect("pressed", Callable(this, "on_save_button_pressed"));
    }

    String part_ui_path = "CanvasLayer/Control/PartSelectPanel/PartVBox/";
    
    Button *head_btn = Object::cast_to<Button>(get_node_or_null(part_ui_path + "HeadButton"));
    if (head_btn) head_btn->connect("pressed", Callable(this, "_on_head_button_pressed"));

    Button *body_btn = Object::cast_to<Button>(get_node_or_null(part_ui_path + "BodyButton"));
    if (body_btn) body_btn->connect("pressed", Callable(this, "_on_body_button_pressed"));

    Button *r_arm_btn = Object::cast_to<Button>(get_node_or_null(part_ui_path + "RightArmButton"));
    if (r_arm_btn) r_arm_btn->connect("pressed", Callable(this, "_on_right_arm_button_pressed"));

    Button *l_arm_btn = Object::cast_to<Button>(get_node_or_null(part_ui_path + "LeftArmButton"));
    if (l_arm_btn) l_arm_btn->connect("pressed", Callable(this, "_on_left_arm_button_pressed"));

    Button *r_leg_btn = Object::cast_to<Button>(get_node_or_null(part_ui_path + "RightLegButton"));
    if (r_leg_btn) r_leg_btn->connect("pressed", Callable(this, "_on_right_leg_button_pressed"));

    Button *l_leg_btn = Object::cast_to<Button>(get_node_or_null(part_ui_path + "LeftLegButton"));
    if (l_leg_btn) l_leg_btn->connect("pressed", Callable(this, "_on_left_leg_button_pressed"));

    load_player_preview();
}

void SkinEditScene::_on_head_button_pressed() { handle_part_cycle("Head"); }
void SkinEditScene::_on_body_button_pressed() { handle_part_cycle("Body"); }
void SkinEditScene::_on_right_arm_button_pressed() { handle_part_cycle("RightArm"); }
void SkinEditScene::_on_left_arm_button_pressed() { handle_part_cycle("LeftArm"); }
void SkinEditScene::_on_right_leg_button_pressed() { handle_part_cycle("RightLeg"); }
void SkinEditScene::_on_left_leg_button_pressed() { handle_part_cycle("LeftLeg"); }

void SkinEditScene::select_preset_for_all(const String &preset_id) {
    logic.select_preset_for_all(preset_id.utf8().get_data());

    SkinPainter *painter = Object::cast_to<SkinPainter>(get_node_or_null("SkinPainter"));
    if (painter) {
        painter->apply_preset_to_all_parts(get_equipped_presets());
    }
    UtilityFunctions::print(vformat("[SkinEdit] Switched presets for all parts: %s", preset_id));
}

void SkinEditScene::handle_part_cycle(const String &part_name) {
    std::string next_preset = logic.cycle_part_preset(part_name.utf8().get_data());
    apply_part_preset_to_painter(part_name, String(next_preset.c_str()));
}

void SkinEditScene::apply_part_preset_to_painter(const String &part_name, const String &preset_id) {
    String res_path = vformat("res://Resources/Skins/%s/%s.png", preset_id, part_name.to_lower());
    SkinPainter *painter = Object::cast_to<SkinPainter>(get_node_or_null("SkinPainter"));
    if (painter) {
        painter->apply_preset_to_part(part_name, res_path);
    }
}

void SkinEditScene::_unhandled_input(const Ref<InputEvent> &event) {
    Ref<InputEventMouseButton> mouse_button = event;
    if (mouse_button.is_valid() && mouse_button->get_button_index() == MouseButton::MOUSE_BUTTON_LEFT) {
        is_dragging = mouse_button->is_pressed();
    }

    if (is_dragging) {
        Ref<InputEventMouseMotion> mouse_motion = event;
        if (mouse_motion.is_valid() && skin_model_container) {
            skin_model_container->rotate_y(mouse_motion->get_relative().x * logic.get_rotate_sensitivity());
        }
    }
}

void SkinEditScene::load_player_preview() {
    ResourceLoader *rl = ResourceLoader::get_singleton();
    Ref<PackedScene> dummy_scene = rl->load(dummy_scene_path);
    if (dummy_scene.is_valid()) {
        Node3D *dummy_instance = Object::cast_to<Node3D>(dummy_scene->instantiate());
        if (dummy_instance) {
            dummy_instance->call("set_process_movement", false);
            dummy_instance->set_position(Vector3(0, 0, 0));

            if (skin_model_container) {
                skin_model_container->add_child(dummy_instance);
            }

            SkinPainter *painter = Object::cast_to<SkinPainter>(get_node_or_null("SkinPainter"));
            if (painter) {
                painter->initialize(dummy_instance);
                painter->apply_preset_to_all_parts(get_equipped_presets());
            }
        }
    } else {
        UtilityFunctions::push_error(vformat("[SkinEdit] Failed to load dummy model: %s", dummy_scene_path));
    }
}

void SkinEditScene::on_save_button_pressed() {
    UtilityFunctions::print("[SkinEdit] Skin settings confirmed:");

    Ref<ConfigFile> config;
    config.instantiate();

    const auto &presets = logic.get_equipped_presets();
    for (const auto &pair : presets) {
        String part = pair.first.c_str();
        String preset = pair.second.c_str();
        config->set_value("PlayerSkin", part, preset);
        UtilityFunctions::print(vformat("  - %s: %s", part, preset));
    }

    Error err = config->save("user://player_skin.cfg");
    if (err == OK) {
        UtilityFunctions::print("[SkinEdit] Skin settings saved successfully.");
    } else {
        UtilityFunctions::push_error("[SkinEdit] Failed to save skin settings.");
    }
}

void SkinEditScene::on_back_button_pressed() {
    SceneTree *st = get_tree();
    if (st) {
        st->change_scene_to_file(lobby_select_scene_path);
    }
}

Dictionary SkinEditScene::get_equipped_presets() const {
    return convert_cpp_map_to_dictionary(logic.get_equipped_presets());
}

void SkinEditScene::set_equipped_presets(const Dictionary &p_presets) {
    logic.set_equipped_presets(convert_dictionary_to_cpp_map(p_presets));
}

void SkinEditScene::set_rotate_sensitivity(float p_val) {
    logic.set_rotate_sensitivity(p_val);
}

float SkinEditScene::get_rotate_sensitivity() const {
    return logic.get_rotate_sensitivity();
}

Dictionary SkinEditScene::convert_cpp_map_to_dictionary(const std::map<std::string, std::string> &map) const {
    Dictionary dict;
    for (const auto &pair : map) {
        dict[String(pair.first.c_str())] = String(pair.second.c_str());
    }
    return dict;
}

std::map<std::string, std::string> SkinEditScene::convert_dictionary_to_cpp_map(const Dictionary &dict) const {
    std::map<std::string, std::string> map;
    Array keys = dict.keys();
    for (int i = 0; i < keys.size(); i++) {
        String key = keys[i];
        String val = dict[key];
        map[key.utf8().get_data()] = val.utf8().get_data();
    }
    return map;
}