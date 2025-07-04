#include <iostream>
#include <string>
#include "cooltime/setup.hpp"
#include "cooltime/set_cooltime.hpp"

void addChargeCupidArrowScore() {
    std::cout << "Adding charge_cupid_arrow score" << std::endl;
}

void activateSkill() {
    std::cout << "Activating skill" << std::endl;
}

void resetChargeCupidArrowScore() {
    std::cout << "Resetting charge_cupid_arrow score" << std::endl;
}

void scheduleChargeFunction() {
    std::cout << "Scheduling charge function" << std::endl;
}

void processCharge() {
    // チャージ時間管理
    addChargeCupidArrowScore();

    // スキル発動
    activateSkill();

    // チャージ用のスコアボードをリセット
    resetChargeCupidArrowScore();

    // 再帰
    scheduleChargeFunction();
}

int main() {
    processCharge();
    return 0;
}
