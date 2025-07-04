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

void processHoankan7() {
    // 通常
    killEntity("7", "camp_red", "!Witch");
    killEntity("7", "camp_pink", "");
    tellPlayer("7");
    tellPlayer("7");
    applySwordEffect();
    killEntity("7", "!camp_red", "");
    killEntity("7", "camp_red", "Witch");

    // ポンコツ用
    damageEntity("7", 1);
    tellPlayer("7");
    applySwordEffect();
}

int main() {
    processHoankan7();
    return 0;
}
