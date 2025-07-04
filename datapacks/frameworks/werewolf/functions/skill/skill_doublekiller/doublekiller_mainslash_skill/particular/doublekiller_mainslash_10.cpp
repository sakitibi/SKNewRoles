#include <iostream>
#include <string>

void damagePlayer(int playerTag) {
    std::cout << "Damaging player with tag: " << playerTag << " by 0.01 fall damage" << std::endl;
}

void applySwordEffect() {
    std::cout << "Applying sword effect" << std::endl;
}

void processDoubleKillerMainSlash10() {
    damagePlayer(10);
    applySwordEffect();
}

int main() {
    processDoubleKillerMainSlash10();
    return 0;
}
