#include "witch_magic.h"
#include "../../../../Player/player_attack.h"

#include <godot_cpp/classes/camera3d.hpp>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/classes/scene_tree.hpp>
#include <godot_cpp/classes/scene_tree_timer.hpp>
#include <godot_cpp/classes/viewport.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/variant/callable.hpp>
#include <godot_cpp/variant/dictionary.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void WitchMagic::_bind_methods() {
    ClassDB::bind_method(D_METHOD("initialize", "scene", "sync_handler"), &WitchMagic::initialize);
    ClassDB::bind_method(D_METHOD("use_skill", "user"), &WitchMagic::use_skill);
    ClassDB::bind_method(D_METHOD("_on_timer_timeout", "user", "target_player_id", "damage_amount"), &WitchMagic::_on_timer_timeout);
}

void WitchMagic::initialize(Node* p_scene, Object* p_sync_handler) {
    scene = p_scene;
    player_combat_sync_handler = p_sync_handler;
}

void WitchMagic::use_skill(Node* user) {
    if (!user || !user->is_inside_tree()) {
        return;
    }

    const uint16_t damage_amount = 20;
    const double delay_seconds = 10.0;

    // 使用タイミングでターゲットを特定
    String target_player_id = get_target_player_id(user);
    if (target_player_id.is_empty()) {
        UtilityFunctions::print("[WitchMagic] 5ブロック以内にターゲットが見つからないため、スキルをキャンセルします。");
        return;
    }

    UtilityFunctions::print(
        String("[WitchMagic] 「魔女の魔法」を使用しました！ ターゲット: {0}。{1}秒後に魔法が発動します。")
            .format(Array::make(target_player_id, delay_seconds))
    );

    Ref<SceneTreeTimer> timer = user->get_tree()->create_timer(delay_seconds);
    if (timer.is_null()) {
        return;
    }

    Callable callback = Callable(this, "_on_timer_timeout").bind(user, target_player_id, damage_amount);
    timer->connect("timeout", callback, CONNECT_ONE_SHOT);
}

void WitchMagic::_on_timer_timeout(Node* user, String target_player_id, uint16_t damage_amount) {
    if (!this || !this->is_inside_tree() || !user || !user->is_inside_tree()) {
        return;
    }

    UtilityFunctions::print(
        String("[WitchMagic] 10秒経過！ 対象 ({0}) に {1} のダメージを与えます。")
            .format(Array::make(target_player_id, (int64_t)damage_amount))
    );

    apply_damage_to_target(target_player_id, damage_amount);
}

String WitchMagic::get_target_player_id(Node* user) {
    if (!scene || !scene->is_inside_tree() || !scene->get_viewport()) {
        return String();
    }

    Camera3D* camera = scene->get_viewport()->get_camera_3d();
    if (!camera) {
        return String();
    }

    Node3D* player_node3d = Object::cast_to<Node3D>(user);
    if (!player_node3d) {
        return String();
    }

    Ref<PlayerAttack> player_attack;
    player_attack.instantiate();
    if (player_attack.is_null()) {
        return String();
    }

    String target_id;
    Dictionary result_dict = player_attack->process_attack(player_node3d, camera);

    if (result_dict.has("target_player_id")) {
        target_id = result_dict["target_player_id"];
    }

    return target_id;
}

void WitchMagic::apply_damage_to_target(const String& target_player_id, uint16_t damage_amount) {
    if (target_player_id.is_empty() || !player_combat_sync_handler) {
        return;
    }

    player_combat_sync_handler->call("OnPlayerAttackedRemote", target_player_id, damage_amount);
}