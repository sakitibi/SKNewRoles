#include <iostream>
#include <unordered_map>
#include <string>

class Shop {
public:
    void setDefaultPrices() {
        setPrice("bread", 1);
        setPrice("tattered_sword", 5);
        setPrice("sturdy_sword", 5);
        setPrice("normal_bow", 5);
        setPrice("normal_arrow", 1);
        setPrice("smoke_bomb", 3);
        setPrice("tnt_bomb", 10);
        setPrice("glowing_tool", 5);
        setPrice("shuffle_tool", 5);
        setPrice("blindness_tool", 5);
        setPrice("same_look_tool", 5);
        setPrice("invisibility_potion", 5);
        setPrice("swiftness_potion", 3);
        setPrice("poison_splash_potion", 5);
        setPrice("slowness_splash_potion", 3);
        setPrice("regeneration_splash_potion", 3);
    }

    void setPrice(const std::string& item, int price) {
        if (prices.find(item) == prices.end()) {
            prices[item] = price;
        }
    }

    void printPrices() const {
        for (const auto& pair : prices) {
            std::cout << pair.first << ": " << pair.second << "\n";
        }
    }

private:
    std::unordered_map<std::string, int> prices;
};

int main() {
    Shop shop;
    shop.setDefaultPrices();
    shop.printPrices();
    return 0;
}
