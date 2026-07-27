#include "falling_block.h"
#include <godot_cpp/classes/box_mesh.hpp>
#include <godot_cpp/classes/box_shape3d.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void SNR2FallingBlock::_bind_methods() {
    ADD_SIGNAL(MethodInfo("block_landed", PropertyInfo(Variant::VECTOR3, "position")));
}

SNR2FallingBlock::SNR2FallingBlock() {
    // 回転を完全固定
    set_lock_rotation_enabled(true);
}

SNR2FallingBlock::~SNR2FallingBlock() {}

void SNR2FallingBlock::_ready() {
    if (Engine::get_singleton()->is_editor_hint()) {
        return;
    }

    // メッシュの生成
    mesh_instance = Object::cast_to<MeshInstance3D>(get_node_or_null("MeshInstance3D"));
    if (mesh_instance == nullptr) {
        mesh_instance = memnew(MeshInstance3D);
        Ref<BoxMesh> box_mesh;
        box_mesh.instantiate();
        box_mesh->set_size(Vector3(1.0f, 1.0f, 1.0f));
        mesh_instance->set_mesh(box_mesh);
        add_child(mesh_instance);
    }

    // コリジョンの生成
    collision_shape = Object::cast_to<CollisionShape3D>(get_node_or_null("CollisionShape3D"));
    if (collision_shape == nullptr) {
        collision_shape = memnew(CollisionShape3D);
        Ref<BoxShape3D> box_shape;
        box_shape.instantiate();
        box_shape->set_size(Vector3(1.0f, 1.0f, 1.0f));
        collision_shape->set_shape(box_shape);
        add_child(collision_shape);
    }

    set_max_contacts_reported(4);
    set_contact_monitor(true);
}

void SNR2FallingBlock::_physics_process(double delta) {
    if (Engine::get_singleton()->is_editor_hint() || is_landed) {
        return;
    }

    Vector3 vel = get_linear_velocity();

    if (Math::abs(vel.y) < 0.1f && get_colliding_bodies().size() > 0) {
        land_check_timer += (float)delta;
        
        // 判定までの時間を短縮（0.03秒）して沈み込みを防止
        if (land_check_timer > 0.03f) {
            on_landed();
        }
    } else {
        land_check_timer = 0.0f;
    }
}

void SNR2FallingBlock::on_landed() {
    if (is_landed) return;
    is_landed = true;
    
    // 物理挙動をフリーズ（静的化）
    set_freeze_enabled(true);

    Vector3 pos = get_global_position();

    pos.x = Math::floor(pos.x) + 0.5f;
    pos.y = Math::floor(pos.y + 0.5f) + 0.5f;
    pos.z = Math::floor(pos.z) + 0.5f;

    set_global_position(pos);

    UtilityFunctions::print("📦 [SNR2FallingBlock] 着地完了座標: ", pos);

    emit_signal("block_landed", pos);
}