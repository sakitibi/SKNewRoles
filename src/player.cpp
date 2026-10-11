#include "player.h"
#include "player_skin.h"
#include "player_movement.h"
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void SNR2Player::_bind_methods() {
    ClassDB::bind_method(D_METHOD("apply_custom_skins"), &SNR2Player::apply_custom_skins);

    ClassDB::bind_method(D_METHOD("get_max_hp"), &SNR2Player::get_max_hp);
    ClassDB::bind_method(D_METHOD("set_max_hp", "p_hp"), &SNR2Player::set_max_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_hp"), "set_max_hp", "get_max_hp");

    ClassDB::bind_method(D_METHOD("get_current_hp"), &SNR2Player::get_current_hp);
    ClassDB::bind_method(D_METHOD("set_current_hp", "p_hp"), &SNR2Player::set_current_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "current_hp"), "set_current_hp", "get_current_hp");

    ClassDB::bind_method(D_METHOD("take_damage", "amount"), &SNR2Player::take_damage);
    ClassDB::bind_method(D_METHOD("heal", "amount"), &SNR2Player::heal);

    ClassDB::bind_method(D_METHOD("die"), &SNR2Player::die);
    ClassDB::bind_method(D_METHOD("set_spectator_mode", "p_enable"), &SNR2Player::set_spectator_mode);
    ClassDB::bind_method(D_METHOD("is_spectator"), &SNR2Player::is_spectator);

    ClassDB::bind_method(D_METHOD("_on_hp_changed", "current_hp", "max_hp"), &SNR2Player::_on_hp_changed);
    ClassDB::bind_method(D_METHOD("_on_hunger_changed", "current_hunger", "max_hunger"), &SNR2Player::_on_hunger_changed);
    ClassDB::bind_method(D_METHOD("_on_player_died"), &SNR2Player::_on_player_died);

    ADD_SIGNAL(MethodInfo("hp_changed", PropertyInfo(Variant::INT, "current_hp"), PropertyInfo(Variant::INT, "max_hp")));
    ADD_SIGNAL(MethodInfo("player_died"));
}

SNR2Player::SNR2Player() {}
SNR2Player::~SNR2Player() {}

void SNR2Player::_ready() {
    input = Input::get_singleton();
    camera = Object::cast_to<Camera3D>(get_node_or_null(NodePath("Camera3D")));

    apply_custom_skins();

    health_component = Object::cast_to<HealthComponent>(get_node_or_null(NodePath("HealthComponent")));
    if (!health_component) {
        health_component = memnew(HealthComponent);
        add_child(health_component);
    }

    spectator_component = Object::cast_to<SpectatorComponent>(get_node_or_null(NodePath("SpectatorComponent")));
    if (!spectator_component) {
        spectator_component = memnew(SpectatorComponent);
        add_child(spectator_component);
    }

    fall_damage_component = Object::cast_to<FallDamageComponent>(get_node_or_null(NodePath("FallDamageComponent")));
    if (!fall_damage_component) {
        fall_damage_component = memnew(FallDamageComponent);
        add_child(fall_damage_component);
    }

    hunger_component = Object::cast_to<HungerComponent>(get_node_or_null(NodePath("HungerComponent")));
    if (!hunger_component) {
        hunger_component = memnew(HungerComponent);
        add_child(hunger_component);
    }

    if (spectator_component) {
        spectator_component->setup(this, camera);
    }

    if (health_component) {
        if (!health_component->is_connected("hp_changed", Callable(this, "_on_hp_changed"))) {
            health_component->connect("hp_changed", Callable(this, "_on_hp_changed"));
        }
        if (!health_component->is_connected("died", Callable(this, "_on_player_died"))) {
            health_component->connect("died", Callable(this, "_on_player_died"));
        }
    }
}

void SNR2Player::apply_custom_skins() {
    PlayerSkin::apply_custom_skins(this);
}

void SNR2Player::_on_hp_changed(int current_hp, int max_hp) {
    emit_signal("hp_changed", current_hp, max_hp);
}

void SNR2Player::_on_hunger_changed(int current_hunger, int max_hunger) {
    emit_signal("hunger_changed", current_hunger, max_hunger);
}

void SNR2Player::_on_player_died() {
    UtilityFunctions::print("[SNR2Player] Death notification received. Switching to Spectator Mode.");
    emit_signal("player_died");
    die();
}

void SNR2Player::_physics_process(double delta) {
    if (!input) return;

    if (is_spectator()) {
        if (spectator_component) {
            spectator_component->process_movement(delta);
        }
        return;
    }

    // 移動処理を外部クラスへ委譲
    PlayerMovement::process_physics(
        this, input, fall_damage_component, hunger_component,
        static_cast<float>(delta), gravity, SPEED, JUMP_VELOCITY, is_spectator()
    );
}

void SNR2Player::_input(const Ref<InputEvent> &event) {
    if (!input) return;

    if (input->is_mouse_button_pressed(MouseButton::MOUSE_BUTTON_RIGHT)) {
        Ref<InputEventMouseMotion> mouse_motion = event;
        if (mouse_motion.is_valid()) {
            Vector2 delta = mouse_motion->get_relative();

            rotate_y(-delta.x * mouse_sensitivity);

            camera_rotation_x -= delta.y * mouse_sensitivity;
            camera_rotation_x = Math::clamp(camera_rotation_x, -LIMIT_ANGLE_X, LIMIT_ANGLE_X);

            if (camera != nullptr) {
                Vector3 cam_rot = camera->get_rotation();
                cam_rot.x = camera_rotation_x;
                camera->set_rotation(cam_rot);
            }
        }
    }
}

void SNR2Player::set_max_hp(int p_hp) {
    if (health_component) health_component->set_max_hp(p_hp);
}

int SNR2Player::get_max_hp() const {
    return health_component ? health_component->get_max_hp() : 0;
}

void SNR2Player::set_current_hp(int p_hp) {
    if (health_component) health_component->set_current_hp(p_hp);
}

int SNR2Player::get_current_hp() const {
    return health_component ? health_component->get_current_hp() : 0;
}

void SNR2Player::take_damage(int amount) {
    if (health_component) health_component->take_damage(amount);
}

void SNR2Player::heal(int amount) {
    if (health_component) health_component->heal(amount);
}

void SNR2Player::die() {
    set_spectator_mode(true);
}

void SNR2Player::set_spectator_mode(bool p_enable) {
    if (spectator_component) {
        spectator_component->set_spectator_mode(p_enable);
    }
}

bool SNR2Player::is_spectator() const {
    return spectator_component ? spectator_component->get_is_spectator() : false;
}