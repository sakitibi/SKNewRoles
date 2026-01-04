#include <iostream>
#include <iterator>
#include <string>
#include <vector>
#include "Startup.hpp"
#include "library.hpp"

std::string callback = "";
std::string version = "v.3.2.0.1";
void logs() {
    const std::string s1 =
    "SekaDynamicLibrary\n"
    "Copyright Sekacraft\n"
    "Modules\n"
    "werewolf\n"
    "Adv_Map_Creator_data\n"
    "magic-and-spells-java\n"
    "Seka_C++Modules\n"
    "名前は長い方が有利とすまない先生死ね\n"
    "Mod限定役のストーリー\n"
    "普通の村人が突然魔力に目覚め\n"
    "魔女になったのだ\n"
    "魔女になって他の村人に魔法を\n"
    "使って害を及ぼしている\n"
    "例えば\n"
    "\033[38;5;57m魔女になって魔法で他の村人を\n"
    "気付れないように服従させていたり\n"
    "気付れないように魔法で他の村人を呪い殺していたり\n"
    "と人に呪いや催眠による殺害や深い眠りなどを及ぼしています\033[0m\n"
    "README.html\n"
    "ワールド/SKNewRoles " + version + "/datapacks/frameworks/data/werewolf/functions/skill/skill_新役の内部ID/*\n"
    "一人の村娘が狼の存在を知り、村の存亡の機を感じ名も無き勇者たちへ依頼をする、\n"
    "この物語の始まり村人ちゃんです\n"
    "実はこの後登場する『霊能者』であるお兄ちゃんの妹で\n"
    "いつも他人を思いやり畑仕事や村のお仕事を手伝っています\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/have_skill/新役の内部ID_skill_cooltime.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/have_skill/新役の内部ID_スキルの内部ID_skill_cooltime.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/have_skill/新役の内部ID_skill.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/have_skill/新役の内部ID_スキルの内部ID_skill.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/set_skill/新役の内部ID_skill_cooltime.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/set_skill/新役の内部ID_スキルの内部ID_skill_cooltime.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/set_skill/新役の内部ID_skill.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/predicates/set_skill/新役の内部ID_スキルの内部ID_skill.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/loot_tables/skill/新役の内部ID_skill/.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/loot_tables/skill/新役の内部ID_スキルの内部ID_skill/.json\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.draw/新役の内部ID.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/item_modifiers/item/skill/新役の内部ID/*\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/work_新役の内部ID/*\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/skill/.switch_skill/*\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/skill/.ini.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.ini.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.set_role_book.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.role_view.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.role_view-2.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.role_view-1.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/role/.role_view 2.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/role/count/新役の内部ID/*\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/role/skill/新役の内部ID/*\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/view_settings_role.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/view_settings_skill.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/view_settings_role_mod.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/view_settings_skill_mod.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/save_settings.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/.settings/.debug/change_role/change_新役の内部ID.cpp\n"
    "ワールド/SKNewRoles " + version + "/datapacks/werewolf/data/werewolf/functions/shop/potions/*\n";
    std::copy(s1.begin(), s1.end(), std::ostream_iterator<char>(std::cout, ""));
    std::cout << std::endl;
    callback = "";
}
int StartUp() {
    while(callback != "quit"){
        std::cout << "入力.." << std::endl;
        std::cin >> callback;
        std::string password = "";
        std::cout << "パスワード" << std::endl;
        std::cin >> password;
        if(password == "SKNewRoles-Env"){
            if(callback == "logs"){
                logs();
            } else if(callback == "start"){
                libraryLoad();
            } else if(callback == "quit"){
                return EXIT_SUCCESS;
            }
        } else {
            std::cout << "パスワードが違います" << std::endl;
        }
    }
    return EXIT_SUCCESS;
}