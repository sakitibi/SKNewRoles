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

void processHoankan1() {
    // 通常
    killEntity("1", "camp_red", "!Witch");
    killEntity("1", "camp_pink", "");
    tellPlayer("1");
    tellPlayer("1");
    applySwordEffect();
    killEntity("1", "!camp_red", "");
    killEntity("1", "camp_red", "Witch");

    // ポンコツ用
    damageEntity("1", 1);
    tellPlayer("1");
    applySwordEffect();
}

int main() {
    processHoankan1();
    return 0;
}
