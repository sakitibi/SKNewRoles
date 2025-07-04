#include <iostream>
#include "werewolf/data/werewolf/functions/.settings/view_settings_other.cpp"

int main() {
    if(!set_daytime.set_value()){
        static int set_daytime = 0;
    }

    if(!set_daytime_minutes.set_value()){
        static int set_daytime_minutes = 0;
    }

    if(!tick_minute.set_value()){
        static int tick_minute = 60;
    }
    
    set_daytime += 1200;
    set_daytime_minutes = set_daytime;
    set_daytime_minutes /= tick_minute;

    std::cout << "set_daytime: " << set_daytime << std::endl;
    std::cout << "set_daytime_minutes: " << set_daytime_minutes << std::endl;

    std::cout << "Calling view_settings_others..." << std::endl;

    return 0;
}
