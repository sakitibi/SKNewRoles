#include "player_attack.h"
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/collision_object3d.hpp>
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include "Game/health_component.h"

using namespace godot;

void PlayerAttack::process_attack(Node3D *player_node, Camera3D *camera) {
    if (!player_node || !camera) return;

    Transform3D cam_transform = camera->get_global_transform();
    Vector3 origin = cam_transform.origin;
    Vector3 forward = -cam_transform.basis.get_column(2);
    Vector3 target = origin + forward * 3.0f;

    Ref<World3D> world = player_node->get_world_3d();
    if (!world.is_valid()) return;

    PhysicsDirectSpaceState3D *space_state = world->get_direct_space_state();
    if (!space_state) return;

    Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(origin, target);
    
    CollisionObject3D *player_col = Object::cast_to<CollisionObject3D>(player_node);
    if (player_col) {
        Array exclude_array;
        exclude_array.push_back(player_col->get_rid());
        query->set_exclude(exclude_array);
    }

    Dictionary result = space_state->intersect_ray(query);
    if (!result.is_empty()) {
        Node *hit_node = Object::cast_to<Node>(result["collider"]);
        if (hit_node) {
            UtilityFunctions::print("[PlayerAttack] Hit object: ", hit_node->get_name());

            HealthComponent *health = Object::cast_to<HealthComponent>(hit_node->get_node_or_null(NodePath("HealthComponent")));
            if (health) {
                int damage = 1;
                health->take_damage(damage);
                UtilityFunctions::print("[PlayerAttack] You dealt damage to the target!");

                player_node->emit_signal("player_attacked", hit_node, damage);
            }
        }
    } else {
        UtilityFunctions::print("[PlayerAttack] There were no targets within range.");
    }
}