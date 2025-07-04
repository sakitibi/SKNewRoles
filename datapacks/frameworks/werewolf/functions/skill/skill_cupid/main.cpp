#include <iostream>
#include <string>
#include "cooltime/setup.hpp"
#include "cooltime/set_cooltime.hpp"

void summonItem() {
    std::cout << "Summoning item: minecraft:carrot_on_a_stick with CustomModelData: 99999" << std::endl;
}

void damageItem() {
    std::cout << "Damaging item: cupid_arrow" << std::endl;
}

void summonAreaEffectCloud() {
    std::cout << "Summoning area effect cloud with tag: cupid_arrow_motion" << std::endl;
}

void modifyEntityMotion() {
    std::cout << "Modifying entity motion from area effect cloud position" << std::endl;
}

void killAreaEffectCloud() {
    std::cout << "Killing area effect cloud with tag: cupid_arrow_motion" << std::endl;
}

void storeMotionX() {
    std::cout << "Storing motion X" << std::endl;
}

void storeMotionY() {
    std::cout << "Storing motion Y" << std::endl;
}

void storeMotionZ() {
    std::cout << "Storing motion Z" << std::endl;
}

void addMotionTag(const std::string& axis) {
    std::cout << "Adding motion tag: " << axis << std::endl;
}

void removeNotYetTag() {
    std::cout << "Removing not_yet tag from cupid_arrow" << std::endl;
}

void playSound() {
    std::cout << "Playing sound: minecraft:cupid_arrow" << std::endl;
}

void processMain() {
    // アイテムを飛ばす
    summonItem();
    damageItem();
    summonAreaEffectCloud();
    modifyEntityMotion();
    killAreaEffectCloud();

    // 壁や床に当たった時に消滅するための例外処理
    storeMotionX();
    addMotionTag("motion_x");

    storeMotionY();
    addMotionTag("motion_y");

    storeMotionZ();
    addMotionTag("motion_z");

    // 処理終了
    removeNotYetTag();

    // 演出等
    playSound();
}

int main() {
    processMain();
    return 0;
}
