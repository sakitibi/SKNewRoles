#include <iostream>
#include <string>

int main() {
    if(!login_check.set_value()){
        int login_check = 0;
    }
    login_check = 1;
    std::cout << "[Scoreboard] result login_check set to " << login_check << std::endl;

    std::cout << "\033[32mWebでログイン出来ました!\033[0m" << std::endl; // Green text
    return 0;
}