#pragma once

#include <godot_cpp/classes/rigid_body3d.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/collision_shape3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {
    class SNR2FallingBlock : public RigidBody3D {
        GDCLASS(SNR2FallingBlock, RigidBody3D)

    private:
        MeshInstance3D *mesh_instance = nullptr;
        CollisionShape3D *collision_shape = nullptr;

        bool is_landed = false;
        float land_check_timer = 0.0f; // 静止検知タイマー

    protected:
        static void _bind_methods();

    public:
        SNR2FallingBlock();
        ~SNR2FallingBlock();

        void _ready() override;
        void _physics_process(double delta) override;

        // 着地時の処理
        void on_landed();
    };
}