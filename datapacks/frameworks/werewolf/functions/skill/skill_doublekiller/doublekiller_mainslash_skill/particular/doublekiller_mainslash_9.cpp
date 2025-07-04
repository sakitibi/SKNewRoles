#include <iostream>
#include <string>

void damagePlayer(int playerTag) {
    std::cout << "Damaging player with tag: " << playerTag << " by 0.01 fall damage" << std::endl;
}

void applySwordEffect() {
    std::cout << "Applying sword effect" << std::endl;
}

void processDoubleKillerMainSlash9() {
    damagePlayer(9);
    applySwordEffect();
}

int main() {
    processDoubleKillerMainSlash9();
    return 0;
}
