#include <iostream>
#include <string>
#include <sstream>

using namespace std;

// Helper function to create a JSON string
string createTellrawJson(const string& text, const string& color, const string& clickEvent = "") {
    stringstream ss;
    ss << "{\\\"text\\\":\\\"" << text << "\\\",\\\"color\\\":\\\"" << color << "\\\"";
    if (!clickEvent.empty()) {
        ss << ",\\\"clickEvent\\\":" << clickEvent;
    }
    ss << "}";
    return ss.str();
}

// Helper function to create a click event JSON
string createClickEventJson(const string& command) {
    return "{\\\"action\\\":\\\"run_command\\\",\\\"value\\\":\\\"" + command + "\\\"}";
}

int main() {
    // Output header
    cout << "tellraw @s {\\\"text\\\":\\\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n[Settings]\\\"}" << endl;

    // Output role settings button
    string roleSettingsButton = createTellrawJson(" [役職人数]", "gold", createClickEventJson("/function werewolf:.settings/view_settings_role"));
    cout << "tellraw @s [" << roleSettingsButton << "]" << endl;

    // Output skill settings button
    string skillSettingsButton = createTellrawJson(" [スキル/特殊能力の詳細設定]", "gold", createClickEventJson("/function werewolf:.settings/view_settings_skill"));
    cout << "tellraw @s [" << skillSettingsButton << "]" << endl;

    // Output shop settings button
    string shopSettingsButton = createTellrawJson(" [ショップの詳細設定]", "gold", createClickEventJson("/function werewolf:.settings/view_settings_shop"));
    cout << "tellraw @s [" << shopSettingsButton << "]" << endl;

    // Output other settings button
    string otherSettingsButton = createTellrawJson(" [その他]", "gold", createClickEventJson("/function werewolf:.settings/view_settings_others"));
    cout << "tellraw @s [" << otherSettingsButton << "]" << endl;

    // Output settings reload command
    cout << "function werewolf:.settings/reload_settings" << endl;

    return 0;
}
