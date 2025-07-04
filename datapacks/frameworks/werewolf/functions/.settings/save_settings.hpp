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

// Helper function to create a JSON score component
string createJsonScoreComponent(const string& name, const string& objective, const string& color = "", const string& font = "") {
    stringstream ss;
    ss << "{\\\"score\\\":{\\\"name\\\":\\\"" << name << "\\\",\\\"objective\\\":\\\"" << objective << "\\\"}";
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
    // Reset the roles list
    cout << "data remove storage settings: roles" << endl;

    // Settings (ver)
    cout << "data modify storage settings: roles append value \'["
         << createJsonTextComponent("Settings (") << ","
         << createJsonNbtComponent("version", "sys:") << ","
         << createJsonTextComponent(")") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF803") << ","
         << createJsonNbtComponent("version", "sys:", "", "settings_negative")
         << "]'" << endl;

    // Game Time
    cout << "data modify storage settings: roles append value \'["
         << createJsonTextComponent("#ゲーム時間\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803")
         << "]'" << endl;

    // First Day Time
    cout << "data modify storage settings: roles append value \'["
         << createJsonTextComponent("  初日の昼: ") << ","
         << createJsonScoreComponent("#GameManager", "set_first_daytime_minutes") << ","
         << createJsonTextComponent("分") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "set_first_daytime_minutes", "", "settings_negative")
         << "]'" << endl;

    // Day Time
    cout << "data modify storage settings: roles append value \'["
         << createJsonTextComponent("  昼: ") << ","
         << createJsonScoreComponent("#GameManager", "set_daytime_minutes") << ","
         << createJsonTextComponent("分", "", "settings4") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "set_daytime_minutes", "", "settings_negative")
         << "]'" << endl;

    // Night Time
    cout << "data modify storage settings: roles append value \'["
         << createJsonTextComponent("  夜: ") << ","
         << createJsonScoreComponent("#GameManager", "set_nighttime_minutes") << ","
         << createJsonTextComponent("分") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "set_nighttime_minutes", "", "settings_negative")
         << "]'" << endl;

    // Random Event
    cout << "execute if data storage sys: {event_active:0} run data modify storage settings: roles append value \'["
         << createJsonTextComponent("#ランダムクエスト: ") << ","
         << createJsonTextComponent("オン", "green") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if data storage sys: {event_active:1} run data modify storage settings: roles append value \'["
         << createJsonTextComponent("#ランダムクエスト: ") << ","
         << createJsonTextComponent("オフ", "red") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    // Task Mode
    cout << "execute if data storage sys: {task_mode:9} run data modify storage settings: roles append value \'["
         << createJsonTextComponent("#採取ポイントの数: ") << ","
         << createJsonTextComponent("デフォルト", "green") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if data storage sys: {task_mode:0} run data modify storage settings: roles append value \'["
         << createJsonTextComponent("#採取ポイントの数: ") << ","
         << createJsonTextComponent("少ない", "green") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if data storage sys: {task_mode:1} run data modify storage settings: roles append value \'["
         << createJsonTextComponent("#採取ポイントの数: ") << ","
         << createJsonTextComponent("普通", "green") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if data storage sys: {task_mode:2} run data modify storage settings: roles append value \'["
         << createJsonTextComponent("#採取ポイントの数: ") << ","
         << createJsonTextComponent("多い", "green") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    // Role Skill Settings
    cout << "data modify storage settings: roles append value \'["
         << createJsonTextComponent("#役職スキル設定") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative")
         << "]'" << endl;

    // Werewolf Skill
    cout << "execute if score 人狼 Role_count matches 1.. if score #GameManager skill_jinrou_slash_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [人狼]    最大回数: ∞ 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_jinrou_slash_frequency") << ","
         << createJsonTextComponent(" 日 ") << ","
         << createJsonScoreComponent("#GameManager", "skill_jinrou_slash_frequency", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if score 人狼 Role_count matches 1.. unless score #GameManager skill_jinrou_slash_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [人狼]    最大回数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_jinrou_slash_limit") << ","
         << createJsonTextComponent(" 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_jinrou_slash_frequency") << ","
         << createJsonTextComponent(" 日") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_jinrou_slash_limit", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_jinrou_slash_frequency", "", "settings_negative")
         << "]'" << endl;

    // Pitfall Master Skill
    cout << "execute if score 罠師 Role_count matches 1.. run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [罠師]    同時設置数: ") << ","
         << createJsonScoreComponent("#GameManager", "pitfall_max_count") << ","
         << createJsonTextComponent(" 個 ") << ","
         << createJsonScoreComponent("#GameManager", "pitfall_max_count", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    // Diviner Skill
    cout << "execute if score 占い師 Role_count matches 1.. if score #GameManager skill_uranai_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [占い師]  最大回数: ∞ 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_uranai_frequency") << ","
         << createJsonTextComponent(" 日 ") << ","
         << createJsonScoreComponent("#GameManager", "skill_uranai_frequency", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if score 占い師 Role_count matches 1.. unless score #GameManager skill_uranai_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [占い師]  最大回数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_uranai_limit") << ","
         << createJsonTextComponent(" 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_uranai_frequency") << ","
         << createJsonTextComponent(" 日") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_uranai_limit", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_uranai_frequency", "", "settings_negative")
         << "]'" << endl;

    // Medium Skill
    cout << "execute if score 霊能者 Role_count matches 1.. if score #GameManager skill_reinou_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [霊能者]  最大回数: ∞ 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_reinou_frequency") << ","
         << createJsonTextComponent(" 日 ") << ","
         << createJsonScoreComponent("#GameManager", "skill_reinou_frequency", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if score 霊能者 Role_count matches 1.. unless score #GameManager skill_reinou_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [霊能者]  最大回数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_reinou_limit") << ","
         << createJsonTextComponent(" 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_reinou_frequency") << ","
         << createJsonTextComponent(" 日") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_reinou_limit", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_reinou_frequency", "", "settings_negative")
         << "]'" << endl;

    // Knight Skill
    cout << "execute if score 騎士 Role_count matches 1.. if score #GameManager skill_kishi_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [騎士]    最大回数: ∞ 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_kishi_frequency") << ","
         << createJsonTextComponent(" 日 ") << ","
         << createJsonScoreComponent("#GameManager", "skill_kishi_frequency", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if score 騎士 Role_count matches 1.. unless score #GameManager skill_kishi_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [騎士]    最大回数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_kishi_limit") << ","
         << createJsonTextComponent(" 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_kishi_frequency") << ","
         << createJsonTextComponent(" 日") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_kishi_limit", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_kishi_frequency", "", "settings_negative")
         << "]'" << endl;

    // Sheriff Skill
    cout << "execute if score シェリフ Role_count matches 1.. if score #GameManager skill_hoankan_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [シェリフ]  最大回数: ∞ 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_frequency") << ","
         << createJsonTextComponent(" 日 ") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_frequency", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if score シェリフ Role_count matches 1.. unless score #GameManager skill_hoankan_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [シェリフ]  最大回数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_limit") << ","
         << createJsonTextComponent(" 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_frequency") << ","
         << createJsonTextComponent(" 日") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_limit", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_frequency", "", "settings_negative")
         << "]'" << endl;

    // Nice Teleporter Skill
    cout << "execute if score ナイステレポーター Role_count matches 1.. if score #GameManager skill_niseteleporter_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [ナイステレポーター]  最大回数: ∞ 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_niseteleporter_frequency") << ","
         << createJsonTextComponent(" 日 ") << ","
         << createJsonScoreComponent("#GameManager", "skill_niseteleporter_frequency", "", "settings_negative") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative")
         << "]'" << endl;

    cout << "execute if score ナイステレポーター Role_count matches 1.. unless score #GameManager skill_niseteleporter_limit matches 0 run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [ナイステレポーター]  最大回数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_niseteleporter_limit") << ","
         << createJsonTextComponent(" 回 / 回復日数: ") << ","
         << createJsonScoreComponent("#GameManager", "skill_niseteleporter_frequency") << ","
         << createJsonTextComponent(" 日") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF803", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_hoankan_limit", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "skill_niseteleporter_frequency", "", "settings_negative")
         << "]'" << endl;

    // Judge Skill
    cout << "execute if score 裁判官 Role_count matches 1.. run data modify storage settings: roles append value \'["
         << createJsonTextComponent("  [裁判官]  裁判時間: ") << ","
         << createJsonScoreComponent("#GameManager", "set_meeting_time_minutes") << ","
         << createJsonTextComponent("分") << ","
         << createJsonTextComponent("\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806\\uF806", "", "settings_negative") << ","
         << createJsonScoreComponent("#GameManager", "set_meeting_time_minutes", "", "settings_negative")
         << "]'" << endl;

    // Assign the list to the boss bar
    for (int i = 1; i <= 20; ++i) {
        cout << "data modify storage settings: line." << i << " set value \'["
             << createJsonTextComponent("", "", "settings" + to_string(i)) << ","
             << "{\\\"interpret\\\":true,\\\"nbt\\\":\\\"roles[" << i - 1 << "]\\\",\\\"storage\\\":\\\"settings:\\\"}"
             << "]'" << endl;
    }

    return 0;
}
