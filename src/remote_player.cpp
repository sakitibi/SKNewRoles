#include "remote_player.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void RemotePlayer::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_target_transform", "px", "py", "pz", "rx", "ry", "rz"), &RemotePlayer::set_target_transform);

    ClassDB::bind_method(D_METHOD("set_process_movement", "p_enable"), &RemotePlayer::set_process_movement);
    ClassDB::bind_method(D_METHOD("get_process_movement"), &RemotePlayer::get_process_movement);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "process_movement"), "set_process_movement", "get_process_movement");
}

RemotePlayer::RemotePlayer() {
    target_position = Vector3(0.0f, 70.0f, 0.0f);
    target_rotation = Quaternion();
    lerp_speed = 15.0f;
    process_movement = true;
}

RemotePlayer::~RemotePlayer() {}

void RemotePlayer::_physics_process(double delta) {
    if (!process_movement) {
        return;
    }

    double blend = lerp_speed * delta;
    if (blend > 1.0) blend = 1.0;

    Vector3 current_pos = get_position();
    Vector3 new_pos = current_pos.lerp(target_position, blend);
    set_position(new_pos);

    Quaternion current_rot = get_quaternion();
    Quaternion new_rot = current_rot.slerp(target_rotation, blend).normalized();
    set_quaternion(new_rot);
}

void RemotePlayer::set_target_transform(float px, float py, float pz, float rx, float ry, float rz) {
    target_position = Vector3(px, py, pz);
    target_rotation = Quaternion::from_euler(Vector3(rx, ry, rz));
}

void RemotePlayer::set_process_movement(bool p_enable) {
    process_movement = p_enable;
}

bool RemotePlayer::get_process_movement() const {
    return process_movement;
}