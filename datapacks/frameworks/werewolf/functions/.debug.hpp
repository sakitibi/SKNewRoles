#include <iostream>
#include ".system/view_settings_role.cpp"
#include ".system/view_settings_role_mod.cpp"

// ANSIカラーコードの例（Linux/macOSターミナルやWindowsの一部端末対応）
const std::string RED = "\033[31m";
const std::string GREEN = "\033[32m";
const std::string AQUA = "\033[36m";
const std::string WHITE = "\033[37m";
const std::string RESET = "\033[0m";

void printRoleSetting() {
    std::cout << "\n\n\n\n\n\n\n\n\n\n\n[Debug_Settings]\n";

    std::cout << " [役職変更]\n";

    std::cout << "  人狼          " << RED << "<変更>" << RESET << "\n";
    std::cout << "  Witch         " << RED << "<変更>" << RESET << "\n";
    std::cout << "  リモコン       " << RED << "<変更>" << RESET << "\n";
    std::cout << "  ダブルキラー    " << RED << "<変更>" << RESET << "\n";
    std::cout << "  イビルゲッサー  " << RED << "<変更>" << RESET << "\n";
    std::cout << "  スナイパー  " << RED << "<変更>" << RESET << "\n";
    std::cout << "  狂人          " << RED << "<変更>" << RESET << "\n";
    std::cout << "  狂信者        " << RED << "<変更>" << RESET << "\n";

    std::cout << "  村人          " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  占い師        " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  霊能者        " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  騎士          " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  共有者        " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  シェリフ        " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  パン屋        " << GREEN << "<変更>" << RESET << "\n";

    std::cout << "  ポンコツ      ";
    std::cout << GREEN << "<人狼> " << RESET;
    std::cout << GREEN << "<罠師> " << RESET;
    std::cout << GREEN << "<占い師> " << RESET;
    std::cout << GREEN << "<霊能者> " << RESET;
    std::cout << GREEN << "<騎士> " << RESET;
    std::cout << GREEN << "<シェリフ> " << RESET << "\n";

    std::cout << "  ナイステレポーター         " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  社長         " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  さつまといも         " << GREEN << "<変更>" << RESET << "\n";
    std::cout << "  シーア         " << GREEN << "<変更>" << RESET << "\n";

    std::cout << "  妖狐          " << AQUA << "<変更>" << RESET << "\n";
    std::cout << "  背徳者        " << AQUA << "<変更>" << RESET << "\n";
    std::cout << "  ジャッカル          " << AQUA << "<変更>" << RESET << "\n";
    std::cout << "  サイドキック        " << AQUA << "<変更>" << RESET << "\n";
    std::cout << "  死神          " << AQUA << "<変更>" << RESET << "\n";
    std::cout << "  キューピット  " << AQUA << "<変更>" << RESET << "\n";

    std::cout << " [その他]\n";

    std::cout << "  ゲームを強制終了          " << GREEN << "<実行>" << RESET << "\n";
    std::cout << "  コマンドログを表示        " << GREEN << "<実行>" << RESET << "\n";
    std::cout << "  コマンドログを非表示      " << GREEN << "<実行>" << RESET << "\n";
}

int main() {
    printRoleSetting();
    return 0;
}