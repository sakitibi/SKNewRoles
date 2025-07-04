#include <iostream>
#include <unordered_map>
#include <string>
#include "setup.hpp"
#include "set_cooltime.hpp"

void addScore(const std::string& player, const std::string& score, int value) {
    std::cout << "Adding " << value << " to score " << score << " for player " << player << std::endl;
}

void playSound(const std::string& sound, const std::string& player, const std::string& position, float volume, float pitch, float minVolume) {
    std::cout << "Playing sound " << sound << " for player " << player << " at " << position << " with volume " << volume << ", pitch " << pitch << ", and min volume " << minVolume << std::endl;
}

void giveEffect(const std::string& player, const std::string& effect, int duration, int amplifier, bool hideParticles) {
    std::cout << "Giving effect " << effect << " to player " << player << " for " << duration << " seconds with amplifier " << amplifier << " and hide particles " << hideParticles << std::endl;
}

void resetScore(const std::string& player, const std::string& score) {
    std::cout << "Resetting score " << score << " for player " << player << std::endl;
}

void scheduleFunction(const std::string& functionName, const std::string& delay) {
    std::cout << "Scheduling function " << functionName << " with delay " << delay << std::endl;
}

void executeFunction(const std::string& functionName) {
    std::cout << "Executing function " << functionName << std::endl;
}

int main() {
    std::unordered_map<std::string, int> scores = {{"charge_roar", 0}};
    std::string player = "@s"; 

    // チャージ時間管理
    if (scores["charge_roar"] >= 0) {
        addScore(player, "charge_roar", 1);
    }

    // チャージ音と効果
    if (scores["charge_roar"] == 1) {
        playSound("entity.player.breath", player, "~ ~ ~", 1.0f, 1.0f, 0.5f);
        giveEffect(player, "slowness", 1, 3, true);
    }

    // スキル発動
    if (scores["charge_roar"] == 20) {
        #include <main.cpp>
    }

    // チャージ用のスコアボードをリセット
    if (scores["charge_roar"] >= 30) {
        resetScore(player, "charge_roar");
    }

    // 再帰
    if (scores["charge_roar"] >= 0) {
        scheduleFunction("werewolf:skill/skill_jinrou/jinrou_roar_skill/charge", "1t");
    }

    return 0;
}
