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

SkinEditScene::SkinEditScene() {
    available_presets.push_back("preset_1");

    equipped_presets["Head"] = "preset_1";
    equipped_presets["Body"] = "preset_1";
    equipped_presets["RightArm"] = "preset_1";
    equipped_presets["LeftArm"] = "preset_1";
    equipped_presets["RightLeg"] = "preset_1";
    equipped_presets["LeftLeg"] = "preset_1";
}

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

void SkinEditScene::_on_head_button_pressed() { cycle_part_preset("Head"); }
void SkinEditScene::_on_body_button_pressed() { cycle_part_preset("Body"); }
void SkinEditScene::_on_right_arm_button_pressed() { cycle_part_preset("RightArm"); }
void SkinEditScene::_on_left_arm_button_pressed() { cycle_part_preset("LeftArm"); }
void SkinEditScene::_on_right_leg_button_pressed() { cycle_part_preset("RightLeg"); }
void SkinEditScene::_on_left_leg_button_pressed() { cycle_part_preset("LeftLeg"); }

void SkinEditScene::select_preset_for_all(const String &preset_id) {
    Array keys = equipped_presets.keys();
    for (int i = 0; i < keys.size(); i++) {
        equipped_presets[keys[i]] = preset_id;
    }

    SkinPainter *painter = Object::cast_to<SkinPainter>(get_node_or_null("SkinPainter"));
    if (painter) {
        painter->apply_preset_to_all_parts(equipped_presets);
    }
    UtilityFunctions::print(vformat("[SkinEdit] 全部位のプリセットを一括切り替えました: %s", preset_id));
}

void SkinEditScene::cycle_part_preset(const String &part_name) {
    String current = "preset_1";
    if (equipped_presets.has(part_name)) {
        current = equipped_presets[part_name];
    }

    int current_index = -1;
    for (int i = 0; i < available_presets.size(); i++) {
        if (available_presets[i] == current) {
            current_index = i;
            break;
        }
    }

    int next_index = (current_index + 1) % available_presets.size();
    String next_preset = available_presets[next_index];
    equipped_presets[part_name] = next_preset;

    apply_part_preset(part_name, next_preset);
}

void SkinEditScene::apply_part_preset(const String &part_name, const String &preset_id) {
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
            skin_model_container->rotate_y(mouse_motion->get_relative().x * rotate_sensitivity);
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
                painter->apply_preset_to_all_parts(equipped_presets);
            }
        }
    } else {
        UtilityFunctions::push_error(vformat("[SkinEdit] ダミーモデルのロードに失敗しました: %s", dummy_scene_path));
    }
}

void SkinEditScene::on_save_button_pressed() {
    UtilityFunctions::print("[SkinEdit] スキン設定を確定しました:");

    Ref<ConfigFile> config;
    config.instantiate();

    Array keys = equipped_presets.keys();
    for (int i = 0; i < keys.size(); i++) {
        String part = keys[i];
        String preset = equipped_presets[part];
        config->set_value("PlayerSkin", part, preset);
        UtilityFunctions::print(vformat("  - %s: %s", part, preset));
    }

    Error err = config->save("user://player_skin.cfg");
    if (err == OK) {
        UtilityFunctions::print("[SkinEdit] スキン設定の保存に成功しました。");
    } else {
        UtilityFunctions::push_error("[SkinEdit] スキン設定の保存に失敗しました。");
    }
}

void SkinEditScene::on_back_button_pressed() {
    Ref<SceneTree> st = get_tree();
    if (st.is_valid()) {
        st->change_scene_to_file(lobby_select_scene_path);
    }
}

Dictionary SkinEditScene::get_equipped_presets() const { return equipped_presets; }
void SkinEditScene::set_equipped_presets(const Dictionary &p_presets) { equipped_presets = p_presets; }

void SkinEditScene::set_rotate_sensitivity(float p_val) { rotate_sensitivity = p_val; }
float SkinEditScene::get_rotate_sensitivity() const { return rotate_sensitivity; }