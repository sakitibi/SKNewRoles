#include "player.h"
#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/input_event_mouse_motion.hpp>
#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/image.hpp>
#include <godot_cpp/classes/image_texture.hpp>
#include <godot_cpp/classes/mesh.hpp>

using namespace godot;

void SNR2Player::_bind_methods() {
    ClassDB::bind_method(D_METHOD("apply_custom_skins"), &SNR2Player::apply_custom_skins);

    ClassDB::bind_method(D_METHOD("get_max_hp"), &SNR2Player::get_max_hp);
    ClassDB::bind_method(D_METHOD("set_max_hp", "p_hp"), &SNR2Player::set_max_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_hp"), "set_max_hp", "get_max_hp");

    ClassDB::bind_method(D_METHOD("get_current_hp"), &SNR2Player::get_current_hp);
    ClassDB::bind_method(D_METHOD("set_current_hp", "p_hp"), &SNR2Player::set_current_hp);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "current_hp"), "set_current_hp", "get_current_hp");

    ClassDB::bind_method(D_METHOD("take_damage", "amount"), &SNR2Player::take_damage);
    ClassDB::bind_method(D_METHOD("heal", "amount"), &SNR2Player::heal);

    ClassDB::bind_method(D_METHOD("die"), &SNR2Player::die);
    ClassDB::bind_method(D_METHOD("set_spectator_mode", "p_enable"), &SNR2Player::set_spectator_mode);
    ClassDB::bind_method(D_METHOD("is_spectator"), &SNR2Player::is_spectator);

    ClassDB::bind_method(D_METHOD("_on_hp_changed", "current_hp", "max_hp"), &SNR2Player::_on_hp_changed);
    ClassDB::bind_method(D_METHOD("_on_player_died"), &SNR2Player::_on_player_died);

    ADD_SIGNAL(MethodInfo("hp_changed", PropertyInfo(Variant::INT, "current_hp"), PropertyInfo(Variant::INT, "max_hp")));
    ADD_SIGNAL(MethodInfo("player_died"));
}

SNR2Player::SNR2Player() {}
SNR2Player::~SNR2Player() {}

void SNR2Player::_ready() {
    input = Input::get_singleton();
    camera = Object::cast_to<Camera3D>(get_node_or_null(NodePath("Camera3D")));

    // カスタムスキンの読み込みを実行
    apply_custom_skins();

    // コンポーネントの取得または生成
    health_component = Object::cast_to<HealthComponent>(get_node_or_null(NodePath("HealthComponent")));
    if (!health_component) {
        health_component = memnew(HealthComponent);
        add_child(health_component);
    }

    spectator_component = Object::cast_to<SpectatorComponent>(get_node_or_null(NodePath("SpectatorComponent")));
    if (!spectator_component) {
        spectator_component = memnew(SpectatorComponent);
        add_child(spectator_component);
    }

    fall_damage_component = Object::cast_to<FallDamageComponent>(get_node_or_null(NodePath("FallDamageComponent")));
    if (!fall_damage_component) {
        fall_damage_component = memnew(FallDamageComponent);
        add_child(fall_damage_component);
    }

    if (spectator_component) {
        spectator_component->setup(this, camera);
    }

    // シグナルの接続
    if (health_component) {
        if (!health_component->is_connected("hp_changed", Callable(this, "_on_hp_changed"))) {
            health_component->connect("hp_changed", Callable(this, "_on_hp_changed"));
        }
        if (!health_component->is_connected("died", Callable(this, "_on_player_died"))) {
            health_component->connect("died", Callable(this, "_on_player_died"));
        }
    }
}

// 全部位のスキン適用処理
void SNR2Player::apply_custom_skins() {
    apply_part_skin("SkinModel/Head", "head_atlas.png");
    apply_part_skin("SkinModel/Body", "body_atlas.png");
    apply_part_skin("SkinModel/RightArm", "rightarm_atlas.png");
    apply_part_skin("SkinModel/LeftArm", "leftarm_atlas.png");
    apply_part_skin("SkinModel/RightLeg", "rightleg_atlas.png");
    apply_part_skin("SkinModel/LeftLeg", "leftleg_atlas.png");
}

// 部位ごとのテクスチャ適用処理
void SNR2Player::apply_part_skin(const String &node_path, const String &file_name) {
    MeshInstance3D *mesh_instance = Object::cast_to<MeshInstance3D>(get_node_or_null(NodePath(node_path)));
    if (!mesh_instance || !mesh_instance->get_mesh().is_valid()) return;

    ProjectSettings *settings = ProjectSettings::get_singleton();
    String relative_path = "user://game_asset/Skins/" + file_name;
    String full_path = settings->globalize_path(relative_path);

    // 画像ファイルが存在するか判定
    if (FileAccess::file_exists(full_path)) {
        Ref<Image> image = Image::load_from_file(full_path);
        if (image.is_valid()) {
            Ref<ImageTexture> texture = ImageTexture::create_from_image(image);

            Ref<Material> base_mat = mesh_instance->get_mesh()->surface_get_material(0);
            Ref<ShaderMaterial> shader_mat = base_mat;

            if (shader_mat.is_valid()) {
                Ref<ShaderMaterial> unique_mat = shader_mat->duplicate();
                unique_mat->set_shader_parameter("texture_albedo", texture);
                mesh_instance->set_material_override(unique_mat);
            }
        }
    }
}