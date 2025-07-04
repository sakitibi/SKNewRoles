#include <iostream>
#include <unordered_map>
#include <string>

class Player {
public:
    std::unordered_map<std::string, std::string> inventory;

    void giveItem(const std::string& key, const std::string& item) {
        inventory[key] = item;
    }

    void executeTool(const std::string& toolKey, const std::string& newItem) {
        if (inventory.find(toolKey) != inventory.end()) {
            std::cout << "Replacing " << inventory[toolKey] << " with " << newItem << std::endl;
            inventory[toolKey] = newItem;
        }
    }

    void printInventory() {
        for (const auto& [key, item] : inventory) {
            std::cout << key << ": " << item << std::endl;
        }
    }
};

int main() {
    Player player;

    // 初期アイテムを与える
    player.giveItem("blindness_tool", "old_blindness_tool");
    player.giveItem("same_look_tool", "old_same_look_tool");
    player.giveItem("glowing_tool", "old_glowing_tool");
    player.giveItem("shuffle_tool", "old_shuffle_tool");
    player.giveItem("nomal_sword", "old_nomal_sword");
    player.giveItem("strong_sword", "old_strong_sword");

    // 各ツールを新しいアイテムに変更
    player.executeTool("blindness_tool", "special_tool/blindness_tool");
    player.executeTool("same_look_tool", "special_tool/same_look_tool");
    player.executeTool("glowing_tool", "special_tool/glowing_tool");
    player.executeTool("shuffle_tool", "special_tool/shuffle_tool");
    player.executeTool("nomal_sword", "weapon/nomal_sword");
    player.executeTool("strong_sword", "weapon/strong_sword");

    // インベントリの内容を表示
    player.printInventory();

    return 0;
}
