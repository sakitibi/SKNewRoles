#include <iostream>
#include <string>

void storeMotion(const std::string& axis, double motionValue) {
    std::cout << "Storing motion for axis: " << axis << " with value: " << motionValue << std::endl;
}

void displayHeartParticles() {
    std::cout << "Displaying heart particles" << std::endl;
}

void killEntity(const std::string& tag) {
    std::cout << "Killing entity with tag: " << tag << std::endl;
}

void modifyEntityMotion() {
    std::cout << "Modifying entity motion" << std::endl;
}

void processBounce() {
    // Motion X
    storeMotion("x", 0.001);
    displayHeartParticles();
    killEntity("motion_x");

    // Motion Y
    storeMotion("y", 0.001);
    displayHeartParticles();
    killEntity("motion_y");

    // Motion Z
    storeMotion("z", 0.001);
    displayHeartParticles();
    killEntity("motion_z");

    // Modify entity motion
    modifyEntityMotion();
}

int main() {
    processBounce();
    return 0;
}
