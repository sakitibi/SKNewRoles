#include <iostream>
#include <string>

void damagePlayer(int playerTag) {
    std::cout << "Damaging player with tag: " << playerTag << " by 0.01 fall damage" << std::endl;
}

void applySwordEffect() {
    std::cout << "Applying sword effect" << std::endl;
}

void processDoubleKillerSubSlash8() {
    damagePlayer(8);
    applySwordEffect();
}

int main() {
    processDoubleKillerSubSlash8();
    return 0;
}
