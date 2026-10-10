#include "player.h"
#include "player_skin.h"
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

    ClassDB::bind_method(D_METHOD("get_max_hunger"), &SNR2Player::get_max_hunger);
    ClassDB::bind_method(D_METHOD("set_max_hunger", "p_hunger"), &SNR2Player::set_max_hunger);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_hunger"), "set_max_hunger", "get_max_hunger");

    ClassDB::bind_method(D_METHOD("get_current_hunger"), &SNR2Player::get_current_hunger);
    ClassDB::bind_method(D_METHOD("set_current_hunger", "p_hunger"), &SNR2Player::set_current_hunger);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "current_hunger"), "set_current_hunger", "get_current_hunger");

    ClassDB::bind_method(D_METHOD("consume_hunger", "amount"), &SNR2Player::consume_hunger);
    ClassDB::bind_method(D_METHOD("restore_hunger", "amount"), &SNR2Player::restore_hunger);

    ClassDB::bind_method(D_METHOD("die"), &SNR2Player::die);
    ClassDB::bind_method(D_METHOD("set_spectator_mode", "p_enable"), &SNR2Player::set_spectator_mode);
    ClassDB::bind_method(D_METHOD("is_spectator"), &SNR2Player::is_spectator);

    ClassDB::bind_method(D_METHOD("_on_hp_changed", "current_hp", "max_hp"), &SNR2Player::_on_hp_changed);
    ClassDB::bind_method(D_METHOD("_on_hunger_changed", "current_hunger", "max_hunger"), &SNR2Player::_on_hunger_changed);
    ClassDB::bind_method(D_METHOD("_on_player_died"), &SNR2Player::_on_player_died);

    ADD_SIGNAL(MethodInfo("hp_changed", PropertyInfo(Variant::INT, "current_hp"), PropertyInfo(Variant::INT, "max_hp")));
    ADD_SIGNAL(MethodInfo("hunger_changed", PropertyInfo(Variant::INT, "current_hunger"), PropertyInfo(Variant::INT, "max_hunger")));
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

    if (hunger_component) {
        if (!hunger_component->is_connected("hunger_changed", Callable(this, "_on_hunger_changed"))) {
            hunger_component->connect("hunger_changed", Callable(this, "_on_hunger_changed"));
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
    UtilityFunctions::print("[SNR2Player] 死亡通知を受信しました。スペクテイターモードに切り替えます。");
    emit_signal("player_died");
    die();
}

void SNR2Player::set_max_hunger(int p_hunger) {
    if (hunger_component) hunger_component->set_max_hunger(p_hunger);
}

int SNR2Player::get_max_hunger() const {
    return hunger_component ? hunger_component->get_max_hunger() : 0;
}

void SNR2Player::set_current_hunger(int p_hunger) {
    if (hunger_component) hunger_component->set_current_hunger(p_hunger);
}

int SNR2Player::get_current_hunger() const {
    return hunger_component ? hunger_component->get_current_hunger() : 0;
}

void SNR2Player::consume_hunger(int amount) {
    if (hunger_component) hunger_component->consume_hunger(amount);
}

void SNR2Player::restore_hunger(int amount) {
    if (hunger_component) hunger_component->restore_hunger(amount);
}

void SNR2Player::_physics_process(double delta) {
    if (!input) return;

    if (is_spectator()) {
        if (spectator_component) {
            spectator_component->process_movement(delta);
        }
        return;
    }

    Vector3 velocity = get_velocity();

    if (!is_on_floor()) {
        velocity.y -= gravity * static_cast<float>(delta);
    }

    if (fall_damage_component) {
        fall_damage_component->process_fall_damage(this);
    }

    bool is_jump_pressed = input->is_key_pressed(KEY_SPACE) || input->is_action_pressed("ui_accept");
    if (is_jump_pressed && is_on_floor()) {
        velocity.y = JUMP_VELOCITY;
        consume_hunger(1);
    }

    Vector2 input_dir = Vector2(0, 0);
    if (input->is_key_pressed(KEY_D) || input->is_action_pressed("ui_right")) input_dir.x += 1.0f;
    if (input->is_key_pressed(KEY_A) || input->is_action_pressed("ui_left")) input_dir.x -= 1.0f;
    if (input->is_key_pressed(KEY_S) || input->is_action_pressed("ui_down")) input_dir.y += 1.0f;
    if (input->is_key_pressed(KEY_W) || input->is_action_pressed("ui_up")) input_dir.y -= 1.0f;

    if (input_dir.length_squared() > 0.0f) {
        input_dir = input_dir.normalized();
        Basis basis = get_global_transform().basis;
        Vector3 forward = -basis.get_column(2);
        Vector3 right = basis.get_column(0);

        forward.y = 0.0f;
        right.y = 0.0f;
        forward.normalize();
        right.normalize();

        Vector3 direction = (forward * -input_dir.y + right * input_dir.x).normalized();
        velocity.x = direction.x * SPEED;
        velocity.z = direction.z * SPEED;
    } else {
        velocity.x = 0.0f;
        velocity.z = 0.0f;
    }

    set_velocity(velocity);
    move_and_slide();
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