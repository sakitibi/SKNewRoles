#pragma once

#include <godot_cpp/classes/character_body3d.hpp>
#include <godot_cpp/classes/input.hpp>
#include "Game/fall_damage_component.h"
#include "Game/hunger_component.h"

namespace godot {
    class PlayerMovement {
        public:
            static void process_physics(
                CharacterBody3D *body,
                Input *input,
                FallDamageComponent *fall_damage_comp,
                HungerComponent *hunger_comp,
                float delta,
                float gravity,
                float speed,
                float jump_velocity,
                bool is_spectator
            );
    };
}