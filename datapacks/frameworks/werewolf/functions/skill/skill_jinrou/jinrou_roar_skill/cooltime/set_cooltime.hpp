#include <iostream>
#include <unordered_map>
#include <string>

std::unordered_map<std::string, int> scoreboard;

void modifyItemDamage(const std::string& entity, const std::string& item, int damage) {
    std::cout << "Modifying item " << item << " for entity " << entity << " to set damage to " << damage << std::endl;
}

int main() {
    int skill_jinrou_roar_cooltime = 5;
    int cooltime_jinrou_roar_10 = 60;
    int cooltime_jinrou_roar_9 = 54;
    int cooltime_jinrou_roar_8 = 48;
    int cooltime_jinrou_roar_7 = 42;
    int cooltime_jinrou_roar_6 = 36;
    int cooltime_jinrou_roar_5 = 30;
    int cooltime_jinrou_roar_4 = 24;
    int cooltime_jinrou_roar_3 = 18;
    int cooltime_jinrou_roar_2 = 12;
    int cooltime_jinrou_roar_1 = 6;

    // クールタイム用ダメージ更新
    if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_10 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_9) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_0");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_9 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_8) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_1");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_8 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_7) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_2");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_7 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_6) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_3");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_6 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_5) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_4");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_5 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_4) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_5");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_4 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_3) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_6");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_3 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_2) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_7");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_2 && skill_jinrou_roar_cooltime >= cooltime_jinrou_roar_1) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_8");
    } else if (skill_jinrou_roar_cooltime < cooltime_jinrou_roar_1 && skill_jinrou_roar_cooltime >= 1) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_9");
    } else if (skill_jinrou_roar_cooltime == 0) {
        modifyItemDamage("@s", "hotbar.8", "werewolf:item/skill/jinrou/roar/cooltime/set_damage_10");
    }

    return 0;
}
