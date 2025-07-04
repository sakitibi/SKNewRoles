#include <iostream>
#include <string>
#include <sstream>

using namespace std;

// Helper function to create a JSON string
string createTellrawJson(const string& text, const string& color, const string& hoverEvent = "", const string& clickEvent = "") {
    stringstream ss;
    ss << "{\\\"text\\\":\\\"" << text << "\\\",\\\"color\\\":\\\"" << color << "\\\"";
    if (!hoverEvent.empty()) {
        ss << ",\\\"hoverEvent\\\":" << hoverEvent;
    }
    if (!clickEvent.empty()) {
        ss << ",\\\"clickEvent\\\":" << clickEvent;
    }
    ss << "}";
    return ss.str();
}

// Helper function to create a hover event JSON
string createHoverEventJson(const string& text) {
    return "{\\\"action\\\":\\\"show_text\\\",\\\"contents\\\":[{\\\"text\\\":\\\"" + text + "\\\"}]}";
}

// Helper function to create a click event JSON
string createClickEventJson(const string& command) {
    return "{\\\"action\\\":\\\"run_command\\\",\\\"value\\\":\\\"" + command + "\\\"}";
}

// Function to display time settings
void displayTimeSettings(const string& timeName, const string& objective, int timeValue, const string& addCommand, const string& removeCommand) {
    string timeText = to_string(timeValue / 20) + " 分";
    string lowerHoverText = "時間を減らす";
    string raiseHoverText = "時間を増やす";
    string lowerColor = "white";
    string raiseColor = "white";
    string lowerClickEvent = removeCommand;
    string raiseClickEvent = addCommand;

    if (timeValue == 1200) {
        lowerHoverText = "これ以上短くできません";
        lowerColor = "dark_red";
        lowerClickEvent = ""; // Disable the lower button
    }

    if (timeValue == 12000) {
        raiseHoverText = "これ以上長くできません";
        raiseColor = "dark_red";
        raiseClickEvent = ""; // Disable the raise button
    }

    string timeSettingText = createTellrawJson("  " + timeName, "gold");
    string lowerText = createTellrawJson(" <  ", lowerColor, createHoverEventJson(lowerHoverText), lowerClickEvent);
    string timeValueText = createTellrawJson(timeText, "white");
    string raiseText = createTellrawJson("  >", raiseColor, createHoverEventJson(raiseHoverText), raiseClickEvent);

    cout << "tellraw @s [" << timeSettingText << "," << lowerText << "," << timeValueText << "," << raiseText << "]" << endl;
}

// Function to display toggle settings
void displayToggleSettings(const string& settingName, bool isActive, const string& activeCommand, const string& inactiveCommand) {
    string toggleText = createTellrawJson("  " + settingName, "gold");
    string toggleStateText = createTellrawJson(" <  " + string(isActive ? "オフ" : "オン") + "  >", isActive ? "dark_red" : "green", "", createClickEventJson(isActive ? inactiveCommand : activeCommand));

    cout << "tellraw @s [" << toggleText << "," << toggleStateText << "]" << endl;
}

int main() {
    // Output header
    cout << "tellraw @s {\\\"text\\\":\\\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n[Settings]\\\"}" << endl;
    cout << "tellraw @s {\\\"text\\\":\\\" [その他]\\\"}" << endl;

    // 初日の昼時間
    displayTimeSettings("初日の昼時間", "#GameManager set_first_daytime", 1200, "/function werewolf:.settings/set_time/set_first_daytime/add_set_first_daytime", "/function werewolf:.settings/set_time/set_first_daytime/remove_first_daytime");

    // 昼時間
    displayTimeSettings("昼時間", "#GameManager set_daytime", 2400, "/function werewolf:.settings/set_time/set_daytime/add_set_daytime", "/function werewolf:.settings/set_time/set_daytime/remove_daytime");

    // 夜時間
    displayTimeSettings("夜時間", "#GameManager set_nighttime", 1200, "/function werewolf:.settings/set_time/set_nighttime/add_set_nighttime", "/function werewolf:.settings/set_time/set_nighttime/remove_nighttime");

    // ランダムイベント
    displayToggleSettings("ランダムクエスト", false, "/function werewolf:.settings/random_event/switch_active", "/function werewolf:.settings/random_event/switch_inactive");

    // 採集ポイント数
    displayToggleSettings("採取ポイントの数", false, "/function werewolf:.settings/task_mode/switch_mode", "/function werewolf:.settings/task_mode/switch_mode");

    // 風車のアニメーション
    displayToggleSettings("風車のアニメーション", false, "/function werewolf:.settings/anim/windmill/play", "/function werewolf:.settings/anim/windmill/stop");

    // Return button
    string returnButtonJson = createTellrawJson("← 戻る", "green", "", createClickEventJson("/function werewolf:.settings/view_settings"));
    cout << "tellraw @s [" << returnButtonJson << "]" << endl;

    // Settings reload command
    cout << "function werewolf:.settings/reload_settings" << endl;

    return 0;
}
