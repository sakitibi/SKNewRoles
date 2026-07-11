#ifndef GRASS_BLOCK_H
#define GRASS_BLOCK_H

#include <godot_cpp/classes/static_body3d.hpp>
#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/variant/color.hpp>

namespace godot {

class SNR2GrassBlock : public StaticBody3D {
    GDCLASS(SNR2GrassBlock, StaticBody3D);

private:
    Color grass_color;

protected:
    static void _bind_methods();

public:
    SNR2GrassBlock();
    ~SNR2GrassBlock();

    void _ready() override;

    // 外部（C#や他のスクリプト、またはインスペクター）から色を変えられるように関数を用意
    void set_grass_color(const Color p_color);
    Color get_grass_color() const;
};

}

#endif // GRASS_BLOCK_H