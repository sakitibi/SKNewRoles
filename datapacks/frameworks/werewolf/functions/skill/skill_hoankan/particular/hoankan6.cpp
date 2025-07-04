#include <iostream>
#include <string>

void killEntity(const std::string& tag, const std::string& camp, const std::string& team) {
    std::cout << "Killing entity with tag: " << tag << ", camp: " << camp << ", team: " << team << std::endl;
}

void tellPlayer(const std::string& tag) {
    std::cout << "Telling player: " << tag << " は人外だったようだ。" << std::endl;
}

void applySwordEffect() {
    std::cout << "Applying sword effect" << std::endl;
}

void damageEntity(const std::string& tag, int damage) {
    std::cout << "Damaging entity with tag: " << tag << " by " << damage << " fall damage" << std::endl;
}

void processHoankan6() {
    // 通常
    killEntity("6", "camp_red", "!Witch");
    killEntity("6", "camp_pink", "");
    tellPlayer("6");
    tellPlayer("6");
    applySwordEffect();
    killEntity("6", "!camp_red", "");
    killEntity("6", "camp_red", "Witch");

    // ポンコツ用
    damageEntity("6", 1);
    tellPlayer("6");
    applySwordEffect();
}

int main() {
    processHoankan6();
    return 0;
}
