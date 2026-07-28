#pragma once

#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/variant/color.hpp>

namespace godot {
    class SNR2GrassBlock : public StaticBody3D {
        GDCLASS(SNR2GrassBlock, StaticBody3D);

        private:
            Color grass_color;

            // 指定した名前の MeshInstance3D ノードを取得し、マテリアルの色を更新するヘルパー関数
            void apply_color_to_mesh(const String &node_name);

        protected:
            static void _bind_methods();

        public:
            SNR2GrassBlock();
            ~SNR2GrassBlock();

            void _ready() override;

            void set_grass_color(const Color p_color);
            Color get_grass_color() const;
    };
}