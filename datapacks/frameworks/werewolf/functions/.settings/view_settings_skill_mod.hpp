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
    bool enabled;
    std::string description;
};

class SkillConfig {
public:
    std::map<std::string, SkillSetting> skills;
    bool witchWeakness = false;

    SkillConfig() {
        skills["witch_slash"] = {"魔女[切り裂く]", 0, 5, 0, 1, 3, 1, true, "魔女のスキル[切り裂く]の最大回数・回復日数"};
        skills["rimokon_slash"] = {"リモコン[切り裂く]", 0, 5, 0, 1, 3, 1, true, "リモコンのスキル[切り裂く]の最大回数・回復日数"};
        skills["rimokon_marking"] = {"リモコン[マーキング]", 0, 5, 0, 1, 3, 1, true, "リモコンのスキル[マーキング]の最大回数・回復日数"};
        skills["rimokon_operation"] = {"リモコン[操作]", 0, 5, 0, 1, 3, 1, true, "リモコンのスキル[操作]の最大回数・回復日数"};
        skills["doublekiller_mainslash"] = {"ダブルキラー[切り裂く(主)]", 0, 5, 0, 1, 3, 1, true, "ダブルキラーのスキル[切り裂く(主)]の最大回数・回復日数"};
        skills["doublekiller_subslash"] = {"ダブルキラー[切り裂く(副)]", 0, 5, 0, 1, 3, 1, true, "ダブルキラーのスキル[切り裂く(副)]の最大回数・回復日数"};
        skills["evilguesser_slash"] = {"イビルゲッサー[切り裂く]", 0, 5, 0, 1, 3, 1, true, "イビルゲッサーのスキル[切り裂く]の最大回数・回復日数"};
        skills["niceteleporter"] = {"ナイステレポーター[テレポート]", 0, 5, 0, 1, 3, 1, true, "ナイステレポーターのスキル[テレポート]の最大回数・回復日数"};
        skills["jackal_slash"] = {"ジャッカル[切り裂く]", 0, 5, 0, 1, 3, 1, true, "ジャッカルのスキル[切り裂く]の最大回数・回復日数"};
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
        std::cout << "\n  魔女の弱体化: " << (witchWeakness ? "オン" : "オフ") << std::endl;
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
    void setWitchWeakness(bool enabled) {
        witchWeakness = enabled;
    }
};

int main() {
    SkillConfig config;
    config.displaySettings();
    
    config.setSkillLimit("witch_slash", 3);
    config.setSkillFrequency("witch_slash", 2);
    config.setWitchWeakness(true);
    config.displaySettings();
    return 0;
}
