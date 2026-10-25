#pragma once

#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/input.hpp>
#include <godot_cpp/classes/input_event.hpp>

namespace godot {
    class PlayerCamera {
        public:
            enum CameraMode {
                FIRST_PERSON,
                THIRD_PERSON_BACK,
                THIRD_PERSON_FRONT,
            };

        private:
            Camera3D *camera = nullptr;
            CameraMode current_camera_mode = FIRST_PERSON;
            float camera_rotation_x = 0.0f;
            const float LIMIT_ANGLE_X = 1.48f;
            float mouse_sensitivity = 0.003f;

            void update_transform();

        public:
            PlayerCamera();
            ~PlayerCamera();

            void setup(Camera3D *p_camera);

            void cycle_camera_mode();
            void handle_input(Node3D *player, const Ref<InputEvent> &event, Input *input);
            
            CameraMode get_current_mode() const { return current_camera_mode; }
            Camera3D *get_camera() const { return camera; }
    };
}