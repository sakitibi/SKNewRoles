#pragma once

#include <godot_cpp/classes/canvas_layer.hpp>
#include <godot_cpp/classes/label.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {
    class HUDManager : public CanvasLayer {
        GDCLASS(HUDManager, CanvasLayer)

    private:
        NodePath player_path;
        NodePath label_path;
        NodePath fps_label_path;

        Node3D *player_node = nullptr;
        Label *position_label = nullptr;
        Label *fps_label = nullptr;

        Node3D *find_local_player();

    protected:
        static void _bind_methods();

    public:
        HUDManager();
        ~HUDManager();

        void _ready() override;
        void _process(double delta) override;

        void set_player_path(const NodePath &p_path);
        NodePath get_player_path() const;

        void set_label_path(const NodePath &p_path);
        NodePath get_label_path() const;

        void set_fps_label_path(const NodePath &p_path);
        NodePath get_fps_label_path() const;
    };
}