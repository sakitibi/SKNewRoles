#include <iostream>
#include <string>
void setCooltime(int skill_cupid_cooltime, int cooltime_cupid_arrow[]) {
    std::string hotbar_item = "hotbar.8 werewolf:item/skill/cupid/cooltime/";

    if (skill_cupid_cooltime < cooltime_cupid_arrow[10] && skill_cupid_cooltime >= cooltime_cupid_arrow[9]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_0" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[9] && skill_cupid_cooltime >= cooltime_cupid_arrow[8]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_1" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[8] && skill_cupid_cooltime >= cooltime_cupid_arrow[7]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_2" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[7] && skill_cupid_cooltime >= cooltime_cupid_arrow[6]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_3" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[6] && skill_cupid_cooltime >= cooltime_cupid_arrow[5]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_4" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[5] && skill_cupid_cooltime >= cooltime_cupid_arrow[4]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_5" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[4] && skill_cupid_cooltime >= cooltime_cupid_arrow[3]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_6" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[3] && skill_cupid_cooltime >= cooltime_cupid_arrow[2]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_7" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[2] && skill_cupid_cooltime >= cooltime_cupid_arrow[1]) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_8" << std::endl;
    } else if (skill_cupid_cooltime < cooltime_cupid_arrow[1] && skill_cupid_cooltime >= 1) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_9" << std::endl;
    } else if (skill_cupid_cooltime == 0) {
        std::cout << "item modify entity @s " << hotbar_item << "set_damage_10" << std::endl;
    }
}
