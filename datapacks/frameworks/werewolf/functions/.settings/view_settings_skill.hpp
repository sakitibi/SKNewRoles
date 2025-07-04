#include <iostream>
#include <string>
#include <map>

struct SkillSetting {
    std::string name;
    int minLimit;
    int maxLimit;
    int limit;
    int minFrequency;
    int maxFrequency;
    int frequency;
    std::string description;
};

class SkillConfig {
public:
    std::map<std::string, SkillSetting> skills;
    int pitfallMaxCount = 1;
    int pitfallMin = 1;
    int pitfallMax = 10;
    int ponkotsuMode = 0; // 0: 狼陣営入り, 1: 狼陣営抜き

    SkillConfig() {
        skills["jinrou_slash"] = {"人狼/アサシン[切り裂く]", 0, 5, 0, 1, 3, 1, "人狼/アサシンのスキル[切り裂く]の最大回数・回復日数"};
        skills["uranai"] = {"占い師[占い]", 0, 5, 0, 1, 3, 1, "占い師のスキル[占い]の最大回数・回復日数"};
        skills["reinou"] = {"霊能者[霊能]", 0, 5, 0, 1, 3, 1, "霊能者のスキル[霊能]の最大回数・回復日数"};
        skills["kishi"] = {"騎士[守護]", 0, 5, 0, 1, 3, 1, "騎士のスキル[守護]の最大回数・回復日数"};
        skills["hoankan"] = {"シェリフ[正義執行]", 0, 5, 0, 1, 3, 1, "シェリフのスキル[正義執行]の最大回数・回復日数"};
    }

    void displaySettings() {
        std::cout << "\n[Settings]\n";
        std::cout << " [スキル/特殊能力の詳細設定]\n";
        for (const auto& [key, skill] : skills) {
            std::cout << "  " << skill.name << " : " << skill.description << std::endl;
            std::cout << "    最大回数: ";
            if (skill.limit == 0) std::cout << "無制限";
            else std::cout << skill.limit << " 回";
            std::cout << " (" << skill.minLimit << "～" << skill.maxLimit << ")\n";
            std::cout << "    回復日数: " << skill.frequency << " 日 (" << skill.minFrequency << "～" << skill.maxFrequency << ")\n";
        }
        std::cout << "\n  罠師[落とし穴]同時設置数: " << pitfallMaxCount << " (" << pitfallMin << "～" << pitfallMax << ")\n";
        std::cout << "  ダミー役職: " << (ponkotsuMode == 0 ? "狼陣営入り" : "狼陣営抜き") << std::endl;
    }

    void setSkillLimit(const std::string& key, int value) {
        auto& skill = skills[key];
        if (value < skill.minLimit) value = skill.minLimit;
        if (value > skill.maxLimit) value = skill.maxLimit;
        skill.limit = value;
    }
    void setSkillFrequency(const std::string& key, int value) {
        auto& skill = skills[key];
        if (value < skill.minFrequency) value = skill.minFrequency;
        if (value > skill.maxFrequency) value = skill.maxFrequency;
        skill.frequency = value;
    }
    void setPitfallMaxCount(int value) {
        if (value < pitfallMin) value = pitfallMin;
        if (value > pitfallMax) value = pitfallMax;
        pitfallMaxCount = value;
    }
    void setPonkotsuMode(int mode) {
        ponkotsuMode = mode;
    }
};

int main() {
    SkillConfig config;
    config.displaySettings();
    
    config.setSkillLimit("jinrou_slash", 3);
    config.setSkillFrequency("jinrou_slash", 2);
    config.setPitfallMaxCount(5);
    config.setPonkotsuMode(1);
    config.displaySettings();
    return 0;
}
