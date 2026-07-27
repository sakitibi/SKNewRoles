#include "remote_player.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void RemotePlayer::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_target_transform", "px", "py", "pz", "rx", "ry", "rz"), &RemotePlayer::set_target_transform);
}

RemotePlayer::RemotePlayer() {
    target_position = Vector3(0.0f, 70.0f, 0.0f);
    target_rotation = Quaternion();
    lerp_speed = 15.0f;
}

RemotePlayer::~RemotePlayer() {}

void RemotePlayer::_physics_process(double delta) {
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
    // 目標座標 (X, Y, Z) を更新
    target_position = Vector3(px, py, pz);

    target_rotation = Quaternion::from_euler(Vector3(rx, ry, rz));
}