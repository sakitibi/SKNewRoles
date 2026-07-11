#ifndef REMOTE_PLAYER_HPP
#define REMOTE_PLAYER_HPP

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/quaternion.hpp>

namespace godot {

class RemotePlayer : public Node3D {
    GDCLASS(RemotePlayer, Node3D);

private:
    Vector3 target_position;
    Quaternion target_rotation;
    float lerp_speed;

protected:
    static void _bind_methods();

public:
    RemotePlayer();
    ~RemotePlayer();

    void _physics_process(double delta) override;
    
    // C#側から X, Y, Z の位置と、X, Y, Z の回転（オイラー角）を受け取る一括メソッド
    void set_target_transform(float px, float py, float pz, float rx, float ry, float rz);
};

}

#endif // REMOTE_PLAYER_HPP