#include <iostream>
#include <random>

int main() {
    // スコア：add_randomを作成
    int add_random = 0;

    // add_randomに0~32767までの乱数を設定
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, 32767);
    add_random = distrib(gen);
    std::cout << "add_random: " << add_random << std::endl;

    // {AddDebug}が1ならsidebarにスコアを表示
    bool AddDebug = false; // ここをtrueにするとスコアを表示
    if (AddDebug) {
        std::cout << "[sidebar] add_random: " << add_random << std::endl;
    }
    return 0;
}
