#include <iostream>
#include <unordered_map>
#include <string>

class Scoreboard {
public:
    void addObjective(const std::string& name) {
        if (objectives.count(name) == 0) {
            objectives[name] = 0;
            std::cout << "Objective created: " << name << "\n";
        }
    }

    void setScore(const std::string& player, const std::string& objective, int value) {
        std::string key = player + ":" + objective;
        scores[key] = value;
        std::cout << "Score set: " << key << " = " << value << "\n";
    }

    void operate(const std::string& target, const std::string& op, const std::string& source) {
        int a = scores[target];
        int b = scores[source];
        if (op == "=") scores[target] = b;
        else if (op == "/=") scores[target] = (b != 0) ? a / b : 0;
        std::cout << "Operate: " << target << " " << op << " " << source << " → " << scores[target] << "\n";
    }

private:
    std::unordered_map<std::string, int> objectives;
    std::unordered_map<std::string, int> scores;
};

class GameState {
public:
    void initGame() {
        std::cout << "ゲーム初期化開始...\n";

        // バージョン確認
        std::cout << "バージョン確認: function werewolf:version\n";

        // ゲーム状態
        if (!dataStorage.count("game_phase"))
            dataStorage["game_phase"] = 0;
        if (!dataStorage.count("game_start"))
            dataStorage["game_start"] = 0;

        // スコアボード
        scoreboard.addObjective("member_count");
        scoreboard.addObjective("death");

        // ゲームルール
        std::cout << "ゲームルール設定\n";

        // 時間初期化
        if (dataStorage["game_phase"] == 0)
            time = 3000;

        // インベントリメニュー関連
        scoreboard.addObjective("inventory_menu");
        scoreboard.addObjective("time_since_death");
        scoreboard.addObjective("ready");
        std::cout << "scoreboard objectives setdisplay list ready\n";

        // 時間管理
        scoreboard.addObjective("tick_second");
        scoreboard.setScore("GameManager", "tick_second", 20);
        scoreboard.addObjective("tick_minute");
        scoreboard.setScore("GameManager", "tick_minute", 1200);

        // ボスバーの初期表示テキスト
        std::cout << "ボスバー表示内容を構築\n";

        // 昼夜サイクル
        initDayNightCycle();
    }

    void initRandomEventsAndSystem() {
        scoreboard.addObjective("rng");
        scoreboard.addObjective(".100");
        scoreboard.setScore("GameManager", ".100", 100);

        scoreboard.addObjective("event_timer");
        scoreboard.addObjective("event_timer_countdown");
        if (!dataStorage.count("event_active"))
            dataStorage["event_active"] = 0;
        
        scoreboard.addObjective("event_timer_divide");
        scoreboard.addObjective("event_timer_update");
        scoreboard.addObjective(".36");
        scoreboard.setScore("GameManager", ".36", 36);

        scoreboard.addObjective("meeting_button");
        if (!dataStorage.count("meeting.active"))
            dataStorage["meeting.active"] = 1;

        if (!dataStorage.count("judge_mode"))
            dataStorage["judge_mode"] = 0;
        if (!dataStorage.count("task_win.active"))
            dataStorage["task_win.active"] = 1;
        if (!dataStorage.count("task_win.count"))
            dataStorage["task_win.count"] = 100;

        scoreboard.addObjective("right_click");
        scoreboard.addObjective("is_sneaking");
        scoreboard.addObjective("login");

        entityTags["child_age_value"] = 3000000;
    }

    void initFinalSettings() {
        std::cout << ".ini モジュール初期化...\n";
        initRoleSystem();
        initSkillSystem();
        initItemSystem();
        initTaskSystem();
        initShopSystem();
        initAnimSystem();
        initVotingSystem();

        for (int i = 1; i <= 5; ++i)
            scoreboard.addObjective("reserve_" + std::to_string(i));
        scoreboard.addObjective("owner");

        bossbar["settings_bossbar.color"] = "pink";
        bossbar["settings_bossbar.visible"] = "false";

        reloadSettings();

        if (dataStorage["game_phase"] == 0) {
            bossbar["settings_bossbar.visible"] = "true";
        }
    }

    void debugAll() {
        for (auto& [k, v] : dataStorage)
            std::cout << "  [Data] " << k << " = " << v << "\n";
        for (auto& [k, v] : bossbar)
            std::cout << "  [Bossbar] " << k << " = " << v << "\n";
        for (auto& [k, v] : entityTags)
            std::cout << "  [EntityTag] " << k << " = " << v << "\n";
    }

private:
    Scoreboard scoreboard;
    std::unordered_map<std::string, int> dataStorage;
    std::unordered_map<std::string, std::string> bossbar;
    std::unordered_map<std::string, int> entityTags;
    int time = 0;

    void initDayNightCycle() {
        scoreboard.addObjective("day");
        scoreboard.addObjective("common_timer");

        scoreboard.addObjective("set_first_daytime");
        if (dataStorage["set_first_daytime"] <= 0)
            scoreboard.setScore("GameManager", "set_first_daytime", 1200);
        scoreboard.addObjective("set_first_daytime_minutes");
        scoreboard.operate("GameManager:set_first_daytime_minutes", "=", "GameManager:set_first_daytime");
        scoreboard.operate("GameManager:set_first_daytime_minutes", "/=", "GameManager:tick_minute");

        scoreboard.addObjective("set_daytime");
        if (dataStorage["set_daytime"] <= 0)
            scoreboard.setScore("GameManager", "set_daytime", 3600);
        scoreboard.addObjective("set_daytime_minutes");
        scoreboard.operate("GameManager:set_daytime_minutes", "=", "GameManager:set_daytime");
        scoreboard.operate("GameManager:set_daytime_minutes", "/=", "GameManager:tick_minute");

        scoreboard.addObjective("set_nighttime");
        if (dataStorage["set_nighttime"] <= 0)
            scoreboard.setScore("GameManager", "set_nighttime", 1200);
        scoreboard.addObjective("set_nighttime_minutes");
        scoreboard.operate("GameManager:set_nighttime_minutes", "=", "GameManager:set_nighttime");
        scoreboard.operate("GameManager:set_nighttime_minutes", "/=", "GameManager:tick_minute");
    }

    // .ini 初期化群
    void initRoleSystem();
    void initSkillSystem();
    void initItemSystem();
    void initTaskSystem();
    void initShopSystem();
    void initAnimSystem();
    void initVotingSystem();

    void reloadSettings() {
        std::cout << " 設定読み込み中... (werewolf:.settings/reload_settings)\n";
    }
};

int main() {
    GameState game;
    game.initGame();
    game.initRandomEventsAndSystem();
    game.initFinalSettings();
    game.debugAll(); // 状態確認（任意）

    return 0;
}
