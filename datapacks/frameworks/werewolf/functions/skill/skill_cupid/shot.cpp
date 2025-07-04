#include <iostream>
#include <string>

void replaceItemIfHolding() {
    std::cout << "Replacing item in main hand if holding cupid skill item" << std::endl;
}

void openScoreboardForSkill() {
    std::cout << "Adding score for charge_cupid_arrow" << std::endl;
}

void setCooldown() {
    std::cout << "Setting skill_cupid_cooltime to 600" << std::endl;
}

void processShot() {
    // キューピットの矢処理
    // アイテムを持っていれば持ち替え
    replaceItemIfHolding();

    // スキル発動のためのスコアボード開放
    openScoreboardForSkill();

    // クールタイム設定
    setCooldown();
}

int main() {
    processShot();
    return 0;
}
