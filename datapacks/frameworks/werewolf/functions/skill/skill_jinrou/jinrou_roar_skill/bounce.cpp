#include <iostream>
#include <string>
#include <unordered_map>

void storeResult(const std::string& entity, const std::string& storage, const std::string& path, double value) {
    std::cout << "Storing result " << value << " from " << entity << " in " << storage << " at path " << path << std::endl;
}

void executeParticle(const std::string& particle, const std::string& position) {
    std::cout << "Executing particle " << particle << " at " << position << std::endl;
}

void killEntity(const std::string& entity) {
    std::cout << "Killing entity " << entity << std::endl;
}

void modifyEntityData(const std::string& entity, const std::string& path, const std::string& sourceEntity, const std::string& sourcePath) {
    std::cout << "Modifying entity " << entity << "'s data at path " << path
              << " from " << sourceEntity << "'s data at " << sourcePath << std::endl;
}

int main() {
    std::unordered_map<std::string, double> motion = {
        {"x", 0.1},
        {"y", 0.0},
        {"z", 0.0}
    };
    std::string entityTags = "motion_x"; // Example: could be "motion_x", "motion_y", or "motion_z"
    std::string entityName = "@s";

    // Motion X
    if (entityTags == "motion_x") {
        storeResult(entityName, "storage item:", "motion", motion["x"] * 0.001);
        if (motion["x"] == 0.0) {
            executeParticle("minecraft:explosion", "~ ~1 ~");
            killEntity(entityName);
        }
    }

    // Motion Y
    if (entityTags == "motion_y") {
        storeResult(entityName, "storage item:", "motion", motion["y"] * 0.001);
        if (motion["y"] == 0.0) {
            executeParticle("minecraft:explosion", "~ ~1 ~");
            killEntity(entityName);
        }
    }

    // Motion Z
    if (entityTags == "motion_z") {
        storeResult(entityName, "storage item:", "motion", motion["z"] * 0.001);
        if (motion["z"] == 0.0) {
            executeParticle("minecraft:explosion", "~ ~1 ~");
            killEntity(entityName);
        }
    }

    modifyEntityData(entityName, "Item.tag.Motion", entityName, "Motion");

    return 0;
}
