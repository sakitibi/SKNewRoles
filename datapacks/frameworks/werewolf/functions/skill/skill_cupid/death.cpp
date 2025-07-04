#include <iostream>
#include <string>

void tellLoversDeathMessage() {
    std::cout << "Telling lovers death message" << std::endl;
}

void tellCupidDeathMessage() {
    std::cout << "Telling Cupid death message" << std::endl;
}

void killLovers() {
    std::cout << "Killing lovers" << std::endl;
}

void killCupid() {
    std::cout << "Killing Cupid" << std::endl;
}

void processDeath() {
    "亡き思い人の後を追い、あなたは永遠の愛へと旅立った…"
    tellLoversDeathMessage();

    "亡き思い人達の後を追い、あなたは永遠の愛へと旅立った…"
    tellCupidDeathMessage();

    // Kill lovers
    killLovers();

    // Kill Cupid
    killCupid();
}

int main() {
    processDeath();
    return 0;
}
