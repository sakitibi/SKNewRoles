#include <iostream>
#include <string>

void damagePlayer(int playerTag) {
    std::cout << "Damaging player with tag: " << playerTag << " by 0.01 fall damage" << std::endl;
}

void applySwordEffect() {
    std::cout << "Applying sword effect" << std::endl;
}

void processDoubleKillerSubSlash4() {
    damagePlayer(4);
    applySwordEffect();
}

int main() {
    processDoubleKillerSubSlash4();
    return 0;
}
