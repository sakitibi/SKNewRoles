#include <iostream>
#include <string>

#define RED     "\033[31m"
#define GREEN   "\033[32m"
#define WHITE   "\033[37m"
#define DARK_RED "\033[1;31m"
#define RESET   "\033[0m"

void printRole(const std::string& name, const std::string& color, int count, int min, int max, const std::string& info, const std::string& addCmd, const std::string& removeCmd) {
    std::cout << color << "  " << name << "  " << RESET;
    if (count <= min) {
        std::cout << DARK_RED << " <" << RESET << "  " << WHITE << count << "  >" << RESET;
        std::cout << " (これ以上人数は減らせません)";
    } else if (count >= max) {
        std::cout << WHITE << " <  " << count << "  " << DARK_RED << ">" << RESET;
        std::cout << " (これ以上人数は増やせません)";
    } else {
        std::cout << WHITE << " <  " << count << "  >" << RESET;
    }
    std::cout << "\n  " << info << std::endl;
    std::cout << "  [人数を増やす: " << addCmd << "] [人数を減らす: " << removeCmd << "]\n";
}

int main() {
    std::cout << "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[Settings]\n";
    // 役説明を表示
    printRole("魔女", RED, 1, 0, 3, "陣営: 狼(Witch)\nスキル: キル, ビーム(夜限定)\n特殊能力: 誰が人狼か知る, 転移の炎", "/function werewolf:.settings/role/count/witch/add", "/function werewolf:.settings/role/count/witch/remove");
    printRole("ﾘﾓｺﾝ", RED, 0, 0, 3, "陣営: 狼(リモコン)\nスキル: キル, マーキング, 操作\n特殊能力: 誰が人狼か知る, 転移の炎", "/function werewolf:.settings/role/count/rimokon/add", "/function werewolf:.settings/role/count/rimokon/remove");
    printRole("ﾀﾞﾌﾞﾙｷﾗｰ", RED, 2, 0, 3, "陣営: 狼(ダブルキラー)\nスキル: キル(2つ)\n特殊能力: 誰が人狼か知る, 転移の炎", "/function werewolf:.settings/role/count/doublekiller/add", "/function werewolf:.settings/role/count/doublekiller/remove");
    printRole("ｲﾋﾞﾙｹﾞｯｻｰ", RED, 1, 0, 3, "陣営: 狼(イビルゲッサー)\nスキル: キル\n特殊能力: 推測射撃, 誰が人狼か知る, 転移の炎", "/function werewolf:.settings/role/count/evilguesser/add", "/function werewolf:.settings/role/count/evilguesser/remove");
    printRole("ｽﾅｲﾊﾟｰ", RED, 3, 0, 3, "陣営: 狼(スナイパー)\nスキル: 射撃\n特殊能力: 誰が人狼か知る, 転移の炎", "/function werewolf:.settings/role/count/sniper/add", "/function werewolf:.settings/role/count/sniper/remove");
    printRole("ﾅｲｽﾃﾚﾎﾟｰﾀｰ", GREEN, 1, 0, 3, "陣営: 村\nスキル: テレポート", "/function werewolf:.settings/role/count/niceteleporter/add", "/function werewolf:.settings/role/count/niceteleporter/remove");
    printRole("ﾅｲｽｹﾞｯｻｰ", GREEN, 2, 0, 3, "陣営: 村\n特殊能力: 推測射撃", "/function werewolf:.settings/role/count/niceguesser/add", "/function werewolf:.settings/role/count/niceguesser/remove");
    printRole("社長", GREEN, 1, 0, 3, "陣営: 村\nスキル: なし\n特殊能力: 生存で全員にエメラルド", "/function werewolf:.settings/role/count/syachou/add_syachou", "/function werewolf:.settings/role/count/syachou/remove_syachou");
    printRole("さつまといも", GREEN, 3, 0, 3, "陣営: 村or狼\nスキル: なし\n特殊能力: 夜が明けると陣営が変わる", "/function werewolf:.settings/role/count/satsumatoimo/add_satsumatoimo", "/function werewolf:.settings/role/count/satsumatoimo/remove_satsumatoimo");
    printRole("ジャッカル", RED, 1, 0, 3, "陣営: 第三陣営(ジャッカル)\nスキル: 切り裂く, サイドキック\n特殊能力: 誰がジャッカルか知る, 転移の炎", "-", "-");
    return 0;
}
