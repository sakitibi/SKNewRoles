#include <iostream>
#include <vector>

void setupCooltime(std::vector<int>& cooltime_cupid_arrow) {
    int reserve_1 = 600;
    int reserve_2 = reserve_1;
    int reserve_3 = 10;
    reserve_2 /= reserve_3;

    // クールタイム更新間隔を記録
    for (int i = 0; i < 10; ++i) {
        cooltime_cupid_arrow[i] = reserve_2;
    }

    // 各クールタイム更新間隔を設定
    for (int i = 1; i <= 10; ++i) {
        cooltime_cupid_arrow[i - 1] *= i;
    }

    // 念のため使用したスコアボードを初期化
    reserve_1 = 0;
    reserve_2 = 0;
    reserve_3 = 0;
}

int main() {
    std::vector<int> cooltime_cupid_arrow(10);
    setupCooltime(cooltime_cupid_arrow);

    // Print the cooltime_cupid_arrow values for verification
    for (int i = 0; i < 10; ++i) {
        std::cout << "cooltime_cupid_arrow_" << (i + 1) << ": " << cooltime_cupid_arrow[i] << std::endl;
    }

    return 0;
}
