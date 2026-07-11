#ifndef LOBBY_MANAGER_H
#define LOBBY_MANAGER_H

#include <godot_cpp/classes/node2d.hpp>
#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/templates/hash_map.hpp>
#include <godot_cpp/variant/string.hpp>

namespace godot {

class LobbyManager : public Node2D {
    GDCLASS(LobbyManager, Node2D);

private:
    Ref<PackedScene> other_player_prefab;
    HashMap<String, Node2D*> other_players;
    Node2D* my_player = nullptr;

protected:
    static void _bind_methods();

public:
    LobbyManager();
    ~LobbyManager();

    void _ready() override;
    
    // インスペクター用のプロパティ
    void set_other_player_prefab(const Ref<PackedScene> &p_prefab);
    Ref<PackedScene> get_other_player_prefab() const;

    // C# 側から他人の移動を受け取るための高速メソッド
    void update_other_player_position(const String &player_id, float x, float y);
};

} // namespace godot

#endif // LOBBY_MANAGER_H