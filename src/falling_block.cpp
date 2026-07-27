#include "falling_block.h"
#include <godot_cpp/classes/box_mesh.hpp>
#include <godot_cpp/classes/box_shape3d.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void SNR2FallingBlock::_bind_methods() {
    // 必要に応じてシグナルやメソッドをバインド
    ADD_SIGNAL(MethodInfo("block_landed", PropertyInfo(Variant::VECTOR3, "position")));
}

SNR2FallingBlock::SNR2FallingBlock() {
    // 物理プロパティの初期設定
    set_lock_rotation_enabled(true); // 落下中に回転しないように固定
}

SNR2FallingBlock::~SNR2FallingBlock() {}

void SNR2FallingBlock::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    mesh_instance = Object::cast_to<MeshInstance3D>(get_node_or_null("MeshInstance3D"));
    if (mesh_instance == nullptr) {
        mesh_instance = memnew(MeshInstance3D);
        Ref<BoxMesh> box_mesh;
        box_mesh.instantiate();
        box_mesh->set_size(Vector3(1.0f, 1.0f, 1.0f));
        mesh_instance->set_mesh(box_mesh);
        add_child(mesh_instance);
    }

    collision_shape = Object::cast_to<CollisionShape3D>(get_node_or_null("CollisionShape3D"));
    if (collision_shape == nullptr) {
        collision_shape = memnew(CollisionShape3D);
        Ref<BoxShape3D> box_shape;
        box_shape.instantiate();
        box_shape->set_size(Vector3(1.0f, 1.0f, 1.0f));
        collision_shape->set_shape(box_shape);
        add_child(collision_shape);
    }

    // 接触検知を有効化
    set_max_contacts_reported(4);
    set_contact_monitor(true);
}

void SNR2FallingBlock::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint() || is_landed) {
        return;
    }

    // 速度がほぼ0になったか、または接地したかを検知
    Vector3 vel = get_linear_velocity();
    if (Math::abs(vel.y) < 0.05f && get_colliding_bodies().size() > 0) {
        land_check_timer += (float)delta;
        
        // 0.1秒間静止したら「着地完了」とみなす
        if (land_check_timer > 0.1f) {
            on_landed();
        }
    } else {
        land_check_timer = 0.0f;
    }
}

void SNR2FallingBlock::on_landed() {
    is_landed = true;
    
    // 物理挙動を停止させてその場に固定
    set_freeze_enabled(true);

    // グリッド（1x1x1など）に座標をスナップ（整列）させる
    Vector3 pos = get_global_position();
    pos.x = Math::round(pos.x);
    pos.y = Math::round(pos.y);
    pos.z = Math::round(pos.z);
    set_global_position(pos);

    UtilityFunctions::print("[SNR2FallingBlock] We have landed: ", pos);

    emit_signal("block_landed", pos);
}