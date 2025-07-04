#include <iostream>
#include <string>
#include <set>

class LanguageStorage {
public:
    std::string lang;

    LanguageStorage(const std::string& initialLang = "") : lang(initialLang) {}

    void checkAndSetLang() {
        std::set<std::string> validLangs = {"ja", "ru"};
        if (validLangs.find(lang) == validLangs.end()) {
            lang = "ja";
            std::cout << "Language set to: " << lang << std::endl;
        } else {
            std::cout << "Language already set: " << lang << std::endl;
        }
    }
};

int main() {
    LanguageStorage storage("");
    storage.checkAndSetLang();
    return 0;
}