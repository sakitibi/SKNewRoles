#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/variant/dictionary.hpp>

namespace godot {
    class PlayerAttack : public RefCounted {
        GDCLASS(PlayerAttack, RefCounted);

        private:
            inline std::pair<Vector3, Vector3> calculate_native_ray_endpoints(const Transform3D &cam_transform, float reach_distance) const {
                Vector3 origin = cam_transform.origin;
                Vector3 forward = -cam_transform.basis.get_column(2);
                Vector3 target = origin + forward * reach_distance;
                return {origin, target};
            }

            inline uint32_t calculate_native_clamped_damage(uint32_t base_damage, uint32_t max_limit = 9999) const {
                return (base_damage > max_limit) ? max_limit : base_damage;
            }

        protected:
            static void _bind_methods();

        public:
            PlayerAttack();
            ~PlayerAttack();

            Dictionary process_attack(Node3D *player_node, Camera3D *camera);
    };
}