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

// Function to display shop item settings
void displayShopItemSettings(const string& itemName, int price, const string& activeCommand, const string& lowerCommand, const string& raiseCommand) {
    string priceText;
    string lowerHoverText = "価格を下げる";
    string raiseHoverText = "価格を上げる";
    string lowerColor = "white";
    string raiseColor = "white";
    string lowerClickEvent = lowerCommand;
    string raiseClickEvent = raiseCommand;

    if (price == 0) {
        priceText = "販売しない";
        lowerHoverText = "これ以上下げられません";
        lowerColor = "dark_red";
        lowerClickEvent = ""; // Disable the lower button
    } else {
        priceText = "\uE300 x" + to_string(price);
    }

    if (price == 20) {
        raiseHoverText = "これ以上上げられません";
        raiseColor = "dark_red";
        raiseClickEvent = ""; // Disable the raise button
    }

    string itemText = createTellrawJson("  " + itemName, "gold");
    string lowerText = createTellrawJson(" < ", lowerColor, createHoverEventJson(lowerHoverText), lowerClickEvent);
    string priceValueText = createTellrawJson(priceText, "white");
    string raiseText = createTellrawJson("  >", raiseColor, createHoverEventJson(raiseHoverText), raiseClickEvent);

    cout << "tellraw @s [" << itemText << "," << lowerText << "," << priceValueText << "," << raiseText << "]" << endl;
}

int main() {
    // Output header
    cout << "tellraw @s {\\\"text\\\":\\\"\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n\\n[Settings]\\\"}" << endl;
    cout << "tellraw @s {\\\"text\\\":\\\" [ショップの詳細設定]\\\"}" << endl;

    // Shop item settings
    displayShopItemSettings("パン", 0, "/function werewolf:.settings/shop/price/bread/active", "/function werewolf:.settings/shop/price/bread/lower", "/function werewolf:.settings/shop/price/bread/raise");
    displayShopItemSettings("ボロい剣", 0, "/function werewolf:.settings/shop/price/tattered_sword/active", "/function werewolf:.settings/shop/price/tattered_sword/lower", "/function werewolf:.settings/shop/price/tattered_sword/raise");
    displayShopItemSettings("良い剣", 0, "/function werewolf:.settings/shop/price/sturdy_sword/active", "/function werewolf:.settings/shop/price/sturdy_sword/lower", "/function werewolf:.settings/shop/price/sturdy_sword/raise");
    displayShopItemSettings("煙玉", 0, "/function werewolf:.settings/shop/price/smoke_bomb/active", "/function werewolf:.settings/shop/price/smoke_bomb/lower", "/function werewolf:.settings/shop/price/smoke_bomb/raise");
    displayShopItemSettings("手投げ爆弾", 0, "/function werewolf:.settings/shop/price/tnt_bomb/active", "/function werewolf:.settings/shop/price/tnt_bomb/lower", "/function werewolf:.settings/shop/price/tnt_bomb/raise");
    displayShopItemSettings("頑丈な弓", 0, "/function werewolf:.settings/shop/price/normal_bow/active", "/function werewolf:.settings/shop/price/normal_bow/lower", "/function werewolf:.settings/shop/price/normal_bow/raise");
    displayShopItemSettings("普通の弓矢", 0, "/function werewolf:.settings/shop/price/normal_arrow/active", "/function werewolf:.settings/shop/price/normal_arrow/lower", "/function werewolf:.settings/shop/price/normal_arrow/raise");
    displayShopItemSettings("発光ツール", 0, "/function werewolf:.settings/shop/price/glowing_tool/active", "/function werewolf:.settings/shop/price/glowing_tool/lower", "/function werewolf:.settings/shop/price/glowing_tool/raise");
    displayShopItemSettings("盲目付与ツール", 0, "/function werewolf:.settings/shop/price/blindness_tool/active", "/function werewolf:.settings/shop/price/blindness_tool/lower", "/function werewolf:.settings/shop/price/blindness_tool/raise");
    displayShopItemSettings("容姿統一ツール", 0, "/function werewolf:.settings/shop/price/same_look_tool/active", "/function werewolf:.settings/shop/price/same_look_tool/lower", "/function werewolf:.settings/shop/price/same_look_tool/raise");
    displayShopItemSettings("透明化のポーション", 0, "/function werewolf:.settings/shop/price/invisibility_potion/active", "/function werewolf:.settings/shop/price/invisibility_potion/lower", "/function werewolf:.settings/shop/price/invisibility_potion/raise");
    displayShopItemSettings("俊敏のポーション", 0, "/function werewolf:.settings/shop/price/swiftness_potion/active", "/function werewolf:.settings/shop/price/swiftness_potion/lower", "/function werewolf:.settings/shop/price/swiftness_potion/raise");
    displayShopItemSettings("毒のスプラッシュポーション", 0, "/function werewolf:.settings/shop/price/poison_splash_potion/active", "/function werewolf:.settings/shop/price/poison_splash_potion/lower", "/function werewolf:.settings/shop/price/poison_splash_potion/raise");
    displayShopItemSettings("鈍化のスプラッシュポーション", 0, "/function werewolf:.settings/shop/price/slowness_splash_potion/active", "/function werewolf:.settings/shop/price/slowness_splash_potion/lower", "/function werewolf:.settings/shop/price/slowness_splash_potion/raise");
    displayShopItemSettings("再生のスプラッシュポーション", 0, "/function werewolf:.settings/shop/price/regeneration_splash_potion/active", "/function werewolf:.settings/shop/price/regeneration_splash_potion/lower", "/function werewolf:.settings/shop/price/regeneration_splash_potion/raise");

    // Return button
    string returnButtonJson = createTellrawJson("← 戻る", "green", "", createClickEventJson("/function werewolf:.settings/view_settings"));
    cout << "tellraw @s [" << returnButtonJson << "]" << endl;

    // Settings reload command
    cout << "function werewolf:.settings/reload_settings" << endl;

    return 0;
}
