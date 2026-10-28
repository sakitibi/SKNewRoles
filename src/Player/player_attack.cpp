#include "player_attack.h"
#include <godot_cpp/classes/world3d.hpp>
#include <godot_cpp/classes/physics_direct_space_state3d.hpp>
#include <godot_cpp/classes/physics_ray_query_parameters3d.hpp>
#include <godot_cpp/classes/collision_object3d.hpp>
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include "../Game/health_component.h"
#include "../Game/hotbar.h"
#include "../Game/combat_registry.h"

using namespace godot;

void PlayerAttack::_bind_methods() {
    ClassDB::bind_method(D_METHOD("process_attack", "player_node", "camera"), &PlayerAttack::process_attack);
}

String PlayerAttack::process_attack(Node3D *player_node, Camera3D *camera) {
    if (!player_node || !camera) return "";

    Transform3D cam_transform = camera->get_global_transform();
    Vector3 origin = cam_transform.origin;
    Vector3 forward = -cam_transform.basis.get_column(2);
    Vector3 target = origin + forward * 3.0f;

    Ref<World3D> world = player_node->get_world_3d();
    if (!world.is_valid()) return "";

    PhysicsDirectSpaceState3D *space_state = world->get_direct_space_state();
    if (!space_state) return "";

    Ref<PhysicsRayQueryParameters3D> query = PhysicsRayQueryParameters3D::create(origin, target);
    query->set_collide_with_areas(true);

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
                uint32_t damage = 1; // デフォルトダメージ

                // ホットバーから現在手に持っているアイテムを取得
                Hotbar *hotbar = Object::cast_to<Hotbar>(player_node->get_node_or_null(NodePath("Hotbar")));
                if (!hotbar) {
                    hotbar = Object::cast_to<Hotbar>(player_node->find_child("Hotbar", true, false));
                }

                if (hotbar) {
                    int selected_slot = hotbar->get_selected_slot();
                    Dictionary slot_data = hotbar->get_slot_item(selected_slot);
                    if (slot_data.has("item_id")) {
                        String held_item = slot_data["item_id"];
                        
                        CombatRegistry *registry = CombatRegistry::get_singleton();
                        if (registry) {
                            damage = registry->get_weapon_damage(held_item);
                        }
                    }
                }

                health->take_damage(damage);
                UtilityFunctions::print(vformat("[PlayerAttack] You dealt %d damage to the target!", damage));
                return "";
            }
            else {
                Node *current = hit_node;
                String target_player_id = "";

                while (current) {
                    if (current->has_meta("player_id")) {
                        target_player_id = current->get_meta("player_id");
                        break;
                    }
                    current = current->get_parent();
                }

                if (!target_player_id.is_empty()) {
                    UtilityFunctions::print("[PlayerAttack] Hit remote player ID: ", target_player_id);
                    return target_player_id;
                } else {
                    UtilityFunctions::print("[PlayerAttack] Hit an object, but player_id metadata was not found.");
                }
            }
        }
    } else {
        UtilityFunctions::print("[PlayerAttack] There were no targets within range.");
    }

    return "";
}