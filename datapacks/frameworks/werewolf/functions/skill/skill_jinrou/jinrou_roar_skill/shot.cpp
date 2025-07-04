#include <iostream>
#include <unordered_map>
#include <string>

void replaceItem(const std::string& entity, const std::string& slot, const std::string& item) {
    std::cout << "Replacing item in slot " << slot << " for entity " << entity << " with " << item << std::endl;
}

void addScore(const std::string& player, const std::string& score, int value) {
    std::cout << "Adding " << value << " to score " << score << " for player " << player << std::endl;
}

void setScore(const std::string& player, const std::string& score, int value) {
    std::cout << "Setting score " << score << " for player " << player << " to " << value << std::endl;
}

int main() {
    std::unordered_map<std::string, int> scores = {{"jinrou_roar_skill_cooltime", 0}};
    std::string player = "@s"; 

    // アイテムを持っていれば持ち替え
    if (scores["jinrou_roar_skill_cooltime"] <= 0) {
        replaceItem(player, "weapon.mainhand", "werewolf:skill/jinrou_roar_skill/cooltime");
    }

    // スキル発動のためのスコアボード開放
    addScore(player, "charge_roar", 0);

    // クールタイム設定
    setScore(player, "skill_jinrou_roar_cooltime", 600);

    return 0;
}
