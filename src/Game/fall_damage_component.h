#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/character_body3d.hpp>

namespace godot {
    class FallDamageComponent : public Node3D {
        GDCLASS(FallDamageComponent, Node3D)
        private:
            bool was_in_air = false;
            float fall_start_y = 0.0f;
            
            // 設定パラメータ
            float safe_fall_height = 3.0f;
            int damage_per_block = 1;

        protected:
            static void _bind_methods();

        public:
            FallDamageComponent();
            ~FallDamageComponent();

            // 毎フレームの移動判定時に呼び出して落下ダメージを計算・適用する
            void process_fall_damage(CharacterBody3D *player);

            // ゲッター・セッター（GodotエディタやC#側から調整したい場合）
            void set_safe_fall_height(float p_height) { safe_fall_height = p_height; }
            float get_safe_fall_height() const { return safe_fall_height; }

            void set_damage_per_block(int p_damage) { damage_per_block = p_damage; }
            int get_damage_per_block() const { return damage_per_block; }
    };
}