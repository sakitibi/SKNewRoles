#include <iostream>
#include <string>
#include <vector>

void summonEntity(const std::string& entity, const std::string& position, const std::vector<std::string>& tags) {
    std::cout << "Summoning entity " << entity << " at " << position << " with tags ";
    for (const auto& tag : tags) {
        std::cout << tag << " ";
    }
    std::cout << std::endl;
}

void applyDamage(const std::string& target, double amount, const std::string& damageType, const std::string& source = "") {
    if (source.empty()) {
        std::cout << "Applying " << amount << " damage of type " << damageType << " to " << target << std::endl;
    } else {
        std::cout << "Applying " << amount << " damage of type " << damageType << " to " << target << " by " << source << std::endl;
    }
}

void executeParticle(const std::string& particle, const std::string& position, const std::string& target) {
    std::cout << "Executing particle " << particle << " at " << position << " for " << target << std::endl;
}

void removeTag(const std::string& entity, const std::string& tag) {
    std::cout << "Removing tag " << tag << " from entity " << entity << std::endl;
}

int main() {
    std::string entity = "@s";
    std::string position = "~ ~ ~";
    std::string target = "@a[team=Cupid]";

    // ヒットタグを削除
    removeTag(entity, "hit_roar");

    // ダメージ元を召喚
    summonEntity("area_effect_cloud", position, {"roar"});

    // ダメージ処理
    applyDamage("@s[type=!player]", 50, "fall");
    applyDamage("@s", 0.01, "fall", "@e[type=area_effect_cloud,tag=roar,limit=1]");

    // 演出
    executeParticle("minecraft:explosion", "~ ~1 ~", target);

    return 0;
}
