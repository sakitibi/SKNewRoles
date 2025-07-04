#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

// Playerクラス定義

class Player {
public:
    std::string name;
    std::string team;
    std::vector<std::string> tags;

    bool hasTag(const std::string& tag) const {
        return std::find(tags.begin(), tags.end(), tag) != tags.end();
    }

    bool inTeam(const std::string& t) const {
        return team == t;
    }

    void sendTitle(const std::string& text, const std::string& font) const {
        std::cout << "[TITLE] " << name << " (" << font << "): " << text << std::endl;
    }

    void giveEffect(const std::string& effect, int duration, int amplifier, bool ambient) const {
        std::cout << "[EFFECT] " << name << " -> " << effect << " (" << duration << "s, amp " << amplifier << ")" << std::endl;
    }

    void replaceItem(const std::string& slot, const std::string& itemID) {
        std::cout << "[ITEM] " << name << " replaced " << slot << " with " << itemID << std::endl;
    }
};

class NBTStorage {
public:
    int item_phase = 0;

    int getInt(const std::string& key) {
        return item_phase;
    }

    void setInt(const std::string& key, int value) {
        item_phase = value;
    }
};

class ModContext {
public:
    std::vector<Player> players;
    NBTStorage sysStorage;
    Player* sender;

    std::vector<Player>& getPlayers() {
        return players;
    }

    Player& getSender() {
        return *sender;
    }

    bool hasAnyPlayerInTeam(const std::string& team) {
        for (auto& p : players) {
            if (p.team == team) return true;
        }
        return false;
    }

    void sendTellraw(Player& player, const std::string& message) {
        std::cout << "[TELLRAW] " << player.name << ": " << message << std::endl;
    }

    void scheduleFunction(const std::string& funcID, float seconds) {
        std::cout << "[SCHEDULE] " << funcID << " in " << seconds << "s" << std::endl;
    }
};

void ProcessItemPhase(ModContext& context) {
    int itemPhase = context.sysStorage.getInt("item_phase");
    if (itemPhase != 0) {
        context.sendTellraw(context.getSender(), "今は使えない。");
        return;
    }

    for (auto& player : context.getPlayers()) {
        if (!player.hasTag("player")) continue;

        if (player.inTeam("Jinrou") || player.inTeam("Asasine")) {
            player.sendTitle(u8"\uF811\uE202\uF811", "announce");
        } else if (!player.inTeam("Jinrou") && !player.inTeam("Asasine") &&
                   !player.inTeam("Witch") && !player.inTeam("Rimokon")) {
            player.sendTitle(u8"\uF811\uE201\uF811", "announce");
        }
    }

    bool witchExists = context.hasAnyPlayerInTeam("Witch");

    for (auto& player : context.getPlayers()) {
        if (!witchExists) {
            if (!player.inTeam("Jinrou") && !player.inTeam("Asasine") &&
                !player.inTeam("Witch") && !player.inTeam("Rimokon") &&
                !player.inTeam("Tenkai") && !player.inTeam("Fusanka")) {
                player.giveEffect("blindness", 10, 0, true);
            }
        } else {
            bool isNeutral = !player.inTeam("Jinrou") && !player.inTeam("Asasine") &&
                             !player.inTeam("Witch") && !player.inTeam("Rimokon") &&
                             !player.inTeam("Tenkai") && !player.inTeam("Fusanka");

            bool isFriendly = (player.inTeam("Jinrou") || player.inTeam("Asasine") ||
                               player.inTeam("Witch") || player.inTeam("Rimokon")) &&
                              (!player.inTeam("Tenkai") && !player.inTeam("Fusanka"));

            if (isNeutral) {
                player.giveEffect("blindness", 30, 255, true);
                player.giveEffect("slowness", 30, 1, true);
                player.giveEffect("wither", 30, 0, true);
            }

            if (isFriendly) {
                player.giveEffect("regeneration", 30, 1, true);
                player.giveEffect("night_vision", 30, 255, true);
            }

            if (player.inTeam("Witch") && !player.inTeam("Tenkai") && !player.inTeam("Fusanka")) {
                player.giveEffect("resistance", 30, 4, true);
            }
        }
    }

    context.getSender().replaceItem("mainhand", "minecraft:air");
    context.scheduleFunction("werewolf:item/blindness_tool/defuse_blindness", 10.0f);
    context.sysStorage.setInt("item_phase", 1);
}

int main() {
    Player player1 = {"", "Jinrou", {"player"}};
    Player player2 = {"", "Witch", {"player"}};
    Player player3 = {"", "", {"player"}};

    ModContext context;
    context.players = {player1, player2, player3};
    context.sender = &context.players[0];

    ProcessItemPhase(context);

    return 0;
}
