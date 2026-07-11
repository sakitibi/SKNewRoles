#include "RemotePlayer.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void RemotePlayer::_bind_methods() {
    // C#の Call() から一括ですべての座標を投げられるようにメソッドをバインド
    ClassDB::bind_method(D_METHOD("set_target_transform", "px", "py", "pz", "rx", "ry", "rz"), &RemotePlayer::set_target_transform);
}

RemotePlayer::RemotePlayer() {
    target_position = Vector3(0.0f, 2.0f, 0.0f);
    target_rotation = Quaternion();
    lerp_speed = 15.0f; // 補間速度（カクカクを消す強さ）。お好みに合わせて調整してください
}

RemotePlayer::~RemotePlayer() {}

void RemotePlayer::_physics_process(double delta) {
    double blend = lerp_speed * delta;
    if (blend > 1.0) blend = 1.0;

    // 1. 位置 (Position X, Y, Z) の滑らかな線形補間 (Lerp)
    Vector3 current_pos = get_position();
    Vector3 new_pos = current_pos.lerp(target_position, blend);
    set_position(new_pos);

    // 2. 回転 (Rotation X, Y, Z) の滑らかな球面線形補間 (Slerp)
    // クォータニオンを用いることで、回転の反転やジンバルロックによるブレを完全に封じ込めます
    Quaternion current_rot = get_quaternion();
    Quaternion new_rot = current_rot.slerp(target_rotation, blend).normalized();
    set_quaternion(new_rot);
}

void RemotePlayer::set_target_transform(float px, float py, float pz, float rx, float ry, float rz) {
    // 目標座標 (X, Y, Z) を更新
    target_position = Vector3(px, py, pz);

    // C#から受け取ったオイラー角（ラジアン）から目標クォータニオンを作成
    target_rotation = Quaternion::from_euler(Vector3(rx, ry, rz));
}