#include <iostream>
#include "werewolf/data/werewolf/functions/.settings/view_settings_other.cpp"

int main() {
    if(!set_meeting_time.has_value()){
        static int set_meeting_time = 0;
    }

    if(!set_meeting_time_minutes.has_value()){
        static int set_meeting_time_minutes = 0;
    }

    if(!tick_minute.has_value()){
        static int tick_minute = 60;
    }

    set_meeting_time -= 1200;
    set_meeting_time_minutes = set_meeting_time;
    set_meeting_time_minutes /= tick_minute;

    std::cout << "set_meeting_time: " << set_meeting_time << std::endl;
    std::cout << "set_meeting_time_minutes: " << set_meeting_time_minutes << std::endl;

    std::cout << "Calling view_settings_others..." << std::endl;

    return 0;
}
