#include <iostream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

// Helper function to create a JSON text component
string createJsonTextComponent(const string& text, const string& color = "", const string& font = "") {
    stringstream ss;
    ss << "{\\\"text\\\":\\\"" << text << "\\\"";
    if (!color.empty()) {
        ss << ",\\\"color\\\":\\\"" << color << "\\\"";
    }
    if (!font.empty()) {
        ss << ",\\\"font\\\":\\\"" << font << "\\\"";
    }
    ss << "}";
    return ss.str();
}

// Helper function to create a JSON NBT component
string createJsonNbtComponent(const string& nbt, const string& storage, const string& color = "", const string& font = "") {
    stringstream ss;
    ss << "{\\\"nbt\\\":\\\"" << nbt << "\\\",\\\"storage\\\":\\\"" << storage << "\\\"";
    if (!color.empty()) {
        ss << ",\\\"color\\\":\\\"" << color << "\\\"";
    }
    if (!font.empty()) {
        ss << ",\\\"font\\\":\\\"" << font << "\\\"";
    }
    ss << "}";
    return ss.str();
}

int main() {
    // Save settings to storage
    cout << "function werewolf:.settings/save_settings" << endl;

    // Update boss bar
    cout << "bossbar set minecraft:settings_bossbar name [";
    for (int i = 1; i <= 20; ++i) {
        if (i > 1) {
            cout << ",";
        }
        cout << createJsonNbtComponent("line." + to_string(i), "settings:");
    }
    cout << "]" << endl;

    return 0;
}
