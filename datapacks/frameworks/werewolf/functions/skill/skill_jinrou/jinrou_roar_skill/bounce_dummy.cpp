#include <iostream>
#include <string>
#include <unordered_map>

void storeResult(const std::string& storage, const std::string& path, double value) {
    std::cout << "Storing result " << value << " in storage " << storage << " at path " << path << std::endl;
}

void executeParticle(const std::string& particle, const std::string& entity) {
    std::cout << "Executing particle " << particle << " for entity " << entity << std::endl;
}

void killEntity(const std::string& entity) {
    std::cout << "Killing entity " << entity << std::endl;
}

void modifyEntityData(const std::string& entity, const std::string& path, const std::string& value) {
    std::cout << "Modifying entity " << entity << " data at path " << path << " to " << value << std::endl;
}

int main() {
    std::string entity = "entity";
    double motion_x = 0.0;
    double motion_y = 0.0;
    double motion_z = 0.0;

    // Motion X
    if (entity == "motion_x") {
        storeResult("item:", "motion", motion_x * 0.001);
        if (motion_x == 0.0) {
            executeParticle("minecraft:explosion", "entity");
            killEntity("entity");
        }
    }

    // Motion Y
    if (entity == "motion_y") {
        storeResult("item:", "motion", motion_y * 0.001);
        if (motion_y == 0.0) {
            executeParticle("minecraft:explosion", "entity");
            killEntity("entity");
        }
    }

    // Motion Z
    if (entity == "motion_z") {
        storeResult("item:", "motion", motion_z * 0.001);
        if (motion_z == 0.0) {
            executeParticle("minecraft:explosion", "entity");
            killEntity("entity");
        }
    }

    modifyEntityData("entity", "Item.tag.Motion", "Motion");

    return 0;
}
