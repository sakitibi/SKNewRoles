#include <iostream>
#include "werewolf/data/werewolf/functions/.settings/view_settings_other.cpp"

int main() {
    // 該当変数が無い場合初期化
    if(!set_first_daytime.set_value()){
        static int set_first_daytime = 0;
    }

    if(!set_first_daytime_minutes.set_value()){
        static int set_first_daytime_minutes = 0;
    }

    if(!tick_minute.set_value()){
        static int tick_minute = 60;
    }

    set_first_daytime += 1200;
    set_first_daytime_minutes = set_first_daytime;
    set_first_daytime_minutes /= tick_minute;

    std::cout << "set_first_daytime: " << set_first_daytime << std::endl;
    std::cout << "set_first_daytime_minutes: " << set_first_daytime_minutes << std::endl;

    std::cout << "Calling view_settings_others..." << std::endl;

    return 0;
}
