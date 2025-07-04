#include <iostream>
#include <string>
#include <map>
#include <vector>

enum class Role {
    Jinrou,      // 人狼
    Asasine,     // アサシン
    Kyoujin,     // 狂人
    Kyoushin,    // 狂信者
    Wanashi,     // 罠師
    Uranai,      // 占い師
    Reinou,      // 霊能者
    Kishi,       // 騎士
    Kyouyuu,     // 共有者
    Hoankan,     // シェリフ
    Panya,       // パン屋
    Ponkotsu     // ポンコツ
};

struct RoleSetting {
    std::string name;
    int minCount;
    int maxCount;
    int count;
    std::string description;
};

class WerewolfSettings {
public:
    std::map<Role, RoleSetting> roles;
    //フレームワークがエラーか起きた時用
    //本来は詳細な説明文が出る
    WerewolfSettings() {
        roles[Role::Jinrou] = {"人狼", 1, 3, 1, "狼(人狼): 切り裂く, 咆哮, 転移の炎"};
        roles[Role::Asasine] = {"アサシン", 1, 3, 0, "狼(人狼): 切り裂く, 透明化, 転移の炎"};
        roles[Role::Kyoujin] = {"狂人", 1, 5, 0, "狼(狂人): なし"};
        roles[Role::Kyoushin] = {"狂信者", 1, 3, 0, "狼(狂人): 誰が人狼か知る"};
        roles[Role::Wanashi] = {"罠師", 1, 3, 0, "狼(狂人): 落とし穴"};
        roles[Role::Uranai] = {"占い師", 1, 3, 0, "村: 占い"};
        roles[Role::Reinou] = {"霊能者", 1, 3, 0, "村: 霊能"};
        roles[Role::Kishi] = {"騎士", 1, 1, 0, "村: 守護"};
        roles[Role::Kyouyuu] = {"共有者", 2, 2, 0, "村: 共有者を知る"};
        roles[Role::Hoankan] = {"シェリフ", 1, 3, 0, "村: 正義執行"};
        roles[Role::Panya] = {"パン屋", 1, 3, 0, "村: パン配布"};
        roles[Role::Ponkotsu] = {"ポンコツ", 0, 3, 0, "村: ダミー役職"};
    }

    void displaySettings() {
        std::cout << "\n[Settings]\n";
        std::cout << " [役職人数]\n";
        for (const auto& [role, setting] : roles) {
            std::cout << "  " << setting.name << " (" << setting.count << ") : " << setting.description << std::endl;
        }
    }

    void increaseRole(Role role) {
        auto& setting = roles[role];
        if (setting.count < setting.maxCount) {
            setting.count++;
            std::cout << setting.name << " increased to " << setting.count << std::endl;
        } else {
            std::cout << setting.name << " はこれ以上増やせません" << std::endl;
        }
    }

    void decreaseRole(Role role) {
        auto& setting = roles[role];
        if (setting.count > setting.minCount) {
            setting.count--;
            std::cout << setting.name << " decreased to " << setting.count << std::endl;
        } else {
            std::cout << setting.name << " はこれ以上減らせません" << std::endl;
        }
    }
};

int main() {
    WerewolfSettings settings;
    settings.displaySettings();
    settings.increaseRole(Role::Jinrou);
    settings.decreaseRole(Role::Jinrou);
    settings.displaySettings();
    return 0;
}
