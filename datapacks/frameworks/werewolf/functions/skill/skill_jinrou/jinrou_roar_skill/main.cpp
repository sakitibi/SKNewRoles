#include <iostream>
#include <string>
#include <unordered_map>
#include "setup.hpp"
#include "set_cooltime.hpp"

void summonEntity(const std::string& entity, const std::string& position, const std::unordered_map<std::string, std::string>& properties) {
    std::cout << "Summoning entity " << entity << " at " << position << " with properties {";
    for (const auto& prop : properties) {
        std::cout << prop.first << ": " << prop.second << ", ";
    }
    std::cout << "}" << std::endl;
}

void modifyEntityData(const std::string& entity, const std::string& path, const std::string& sourceEntity, const std::string& sourcePath) {
    std::cout << "Modifying entity " << entity << "'s data at path " << path
              << " from " << sourceEntity << "'s data at " << sourcePath << std::endl;
}

void applyDamage(const std::string& target, double amount) {
    std::cout << "Applying " << amount << " damage to " << target << std::endl;
}

void storeResult(const std::string& entity, const std::string& storage, const std::string& path, double value) {
    std::cout << "Storing result " << value << " from " << entity << " in " << storage << " at path " << path << std::endl;
}

void addTag(const std::string& entity, const std::string& tag) {
    std::cout << "Adding tag " << tag << " to entity " << entity << std::endl;
}

void removeTag(const std::string& entity, const std::string& tag) {
    std::cout << "Removing tag " << tag << " from entity " << entity << std::endl;
}

void playSound(const std::string& sound, const std::string& target, const std::string& position, float volume, float pitch, float minVolume) {
    std::cout << "Playing sound " << sound << " for target " << target << " at " << position << " with volume " << volume << ", pitch " << pitch << ", and min volume " << minVolume << std::endl;
}

void killEntity(const std::string& entity) {
    std::cout << "Killing entity " << entity << std::endl;
}

int main() {
    std::string entity = "@s";
    std::string position = "^ ^-0.25 ^";
    std::string target = "@a";

    // アイテムを飛ばす
    summonEntity("item", position, {
        {"Item", "{id:\"minecraft:carrot_on_a_stick\",Count:1b,tag:{CustomModelData:99999}}"},
        {"Health", "1s"},
        {"PickupDelay", "10000"},
        {"Tags", "[\"roar\",\"not_yet\"]"},
        {"NoGravity", "true"},
        {"Age", "5950"}
    });

    applyDamage("@e[type=item,limit=1,sort=nearest,tag=roar,tag=not_yet]", 0.0);

    summonEntity("area_effect_cloud", "^ ^ ^1.5", {{"Tags", "[\"roar_motion\"]"}});
    modifyEntityData("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "Motion", "@e[type=area_effect_cloud,tag=roar_motion,limit=1]", "Pos");
    killEntity("@e[type=area_effect_cloud,tag=roar_motion,limit=1]");

    // 壁や床に当たった時に消滅するための例外処理
    storeResult("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "item:", "motion", 0.001);
    addTag("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "motion_x");

    storeResult("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "item:", "motion", 0.001);
    addTag("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "motion_y");

    storeResult("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "item:", "motion", 0.001);
    addTag("@e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest]", "motion_z");

    // 処理終了
    removeTag("@e[type=item,tag=roar,tag=not_yet,sort=nearest,limit=1]", "not_yet");

    // 演出等
    playSound("entity.warden.sonic_boom", target, "~ ~ ~", 1.0f, 1.0f, 0.5f);

    return 0;
}
