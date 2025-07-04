#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>

enum GamePhase {
    STANDBY = 0,
    PLAYING = 1,
    MEETING = 99
};

class Player {
public:
    std::string name;
    int loginScore = 0;
    int rightClick = 0;
    int isSneaking = 0;
    bool banned = false;

    Player(std::string name) : name(name) {}
};

class GameSystem {
private:
    std::unordered_map<std::string, Player> players;
    GamePhase phase = STANDBY;
    std::vector<std::string> bannedPlayers = { "water_challenge", "NMNGyuri" }; //要注意人物はバン

public:
    void tick() {
        for (auto& [name, player] : players) {
            if (player.loginScore == 0) {
                firstTimeLogin(player);
            }
            if (player.loginScore >= 3) {
                everyTimeLogin(player);
            }
        }

        switch (phase) {
            case STANDBY:
                standbyPhase();
                break;
            case PLAYING:
                playingPhase();
                break;
            case MEETING:
                meetingPhase();
                break;
            default:
                victoryCheck();
                break;
        }

        killExperienceOrbs();
        killDroppedItems();
        useSmokeBombs();
        useTntBombs();

        for (auto& [_, player] : players) {
            if (player.rightClick >= 1) player.rightClick = 0;
            if (player.isSneaking >= 1 && !isActuallySneaking(player)) {
                player.isSneaking = 0;
            }
        }

        for (const std::string& name : bannedPlayers) {
            if (players.count(name)) {
                players[name].banned = true;
                std::cout << name << " has been banned and removed.\n";
                players.erase(name);
            }
        }
    }

    void addPlayer(const std::string& name) {
        players.emplace(name, Player(name));
    }

    void setPhase(GamePhase newPhase) {
        phase = newPhase;
    }

    // 処理
    void firstTimeLogin(Player& p) { std::cout << p.name << " logged in (first time)\n"; p.loginScore = 3; }
    void everyTimeLogin(Player& p) { std::cout << p.name << " logged in (returning)\n"; }
    void standbyPhase() { std::cout << "[System] Standby phase running\n"; }
    void playingPhase() { std::cout << "[System] Game is in progress\n"; }
    void meetingPhase() { std::cout << "[System] Meeting phase in progress\n"; }
    void victoryCheck() { std::cout << "[System] Checking victory conditions\n"; }
    void killExperienceOrbs() { std::cout << "[System] Killed all XP orbs\n"; }
    void killDroppedItems() { std::cout << "[System] Removed no-drop tagged items\n"; }
    void useSmokeBombs() { std::cout << "[Item] Smoke bomb effects applied\n"; }
    void useTntBombs() { std::cout << "[Item] TNT bomb effects applied\n"; }
    bool isActuallySneaking(const Player& p) { return false; }
};

int main() {
    GameSystem game;
    // 状態変更
    game.setPhase(PLAYING);

    // ゲームの1フレーム処理
    game.tick();

    return 0;
}