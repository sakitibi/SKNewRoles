#include <iostream>
#include <string>

void removeHitCupidArrowTag() {
    std::cout << "Removing hit_cupid_arrow tag" << std::endl;
}

void addLoversTag() {
    std::cout << "Adding lovers tag" << std::endl;
}

void addLovers2Tag() {
    std::cout << "Adding lovers_2 tag" << std::endl;
}

void notifyPotentialLover() {
    std::cout << "Notifying potential lover" << std::endl;
}

void addLovers1Tag() {
    std::cout << "Adding lovers_1 tag" << std::endl;
}

void announceLovers() {
    std::cout << "Announcing lovers" << std::endl;
}

void playLoveSound() {
    std::cout << "Playing love sound" << std::endl;
}

void displayHeartParticles() {
    std::cout << "Displaying heart particles" << std::endl;
}

void removeIncompleteLoversTags() {
    std::cout << "Removing incomplete lovers tags" << std::endl;
}

void processDamage() {
    // ヒットタグを削除
    removeHitCupidArrowTag();

    // タグ処理
    addLoversTag();
    addLovers2Tag();
    notifyPotentialLover();
    addLovers1Tag();
    notifyPotentialLover();
    announceLovers();
    announceLovers();

    // 演出等
    playLoveSound();
    playLoveSound();
    displayHeartParticles();
    displayHeartParticles();

    // カップル完成時にカップル未完成のラバーズタグを削除
    removeIncompleteLoversTags();
    removeIncompleteLoversTags();
    removeIncompleteLoversTags();
}

int main() {
    processDamage();
    return 0;
}
