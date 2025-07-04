#include <iostream>
#include <unordered_map>
#include <string>

std::unordered_map<std::string, int> scoreboard;

void resetScore(const std::string& player, const std::string& score) {
    scoreboard[player + "_" + score] = 0;
    std::cout << "Reset score " << score << " for player " << player << std::endl;
}

void setScore(const std::string& player, const std::string& score, int value) {
    scoreboard[player + "_" + score] = value;
    std::cout << "Set score " << score << " for player " << player << " to " << value << std::endl;
}

void operationScore(const std::string& player, const std::string& score, const std::string& operation, const std::string& targetPlayer, const std::string& targetScore) {
    if (operation == "=") {
        scoreboard[player + "_" + score] = scoreboard[targetPlayer + "_" + targetScore];
    } else if (operation == "/=") {
        scoreboard[player + "_" + score] /= scoreboard[targetPlayer + "_" + targetScore];
    } else if (operation == "*=") {
        scoreboard[player + "_" + score] *= scoreboard[targetPlayer + "_" + targetScore];
    }
    std::cout << "Operation " << operation << " on score " << score << " for player " << player << " with target " << targetScore << " for player " << targetPlayer << std::endl;
}

int main() {
    // 使用するスコアボードを初期化
    resetScore("#GameManager", "reserve_1");
    resetScore("#GameManager", "reserve_2");
    resetScore("#GameManager", "reserve_3");
    resetScore("#GameManager", "reserve_4");

    // クールタイム更新間隔を計算
    setScore("#GameManager", "reserve_1", 600);
    operationScore("#GameManager", "reserve_2", "=", "#GameManager", "reserve_1");
    setScore("#GameManager", "reserve_3", 10);
    operationScore("#GameManager", "reserve_2", "/=", "#GameManager", "reserve_3");

    // クールタイム更新間隔を記録
    for (int i = 1; i <= 10; ++i) {
        operationScore("#GameManager", "cooltime_jinrou_roar_" + std::to_string(i), "=", "#GameManager", "reserve_2");
    }

    // 2から10までのクールタイム更新間隔を設定
    for (int i = 2; i <= 10; ++i) {
        setScore("#GameManager", "reserve_4", i);
        operationScore("#GameManager", "cooltime_jinrou_roar_" + std::to_string(i), "*=", "#GameManager", "reserve_4");
    }

    // 念のため使用したスコアボードを初期化
    resetScore("#GameManager", "reserve_1");
    resetScore("#GameManager", "reserve_2");
    resetScore("#GameManager", "reserve_3");
    resetScore("#GameManager", "reserve_4");

    return 0;
}
