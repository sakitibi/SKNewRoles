#include <iostream>
#include <string>

void damagePlayer(int playerTag) {
    std::cout << "Damaging player with tag: " << playerTag << " by 0.01 fall damage" << std::endl;
}

void applySwordEffect() {
    std::cout << "Applying sword effect" << std::endl;
}

void processDoubleKillerSubSlash5() {
    damagePlayer(5);
    applySwordEffect();
}

int main() {
    processDoubleKillerSubSlash5();
    return 0;
}
