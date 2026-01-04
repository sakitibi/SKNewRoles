#include <iostream>
#include <iterator>
#include <string>
#include <vector>

std::string callback = "";
void logs() {
    const std::string s1 =
    "фудзи Сота 2014-06-02\n"
    "かいき いっき2016-01-29\n"
    "さわい はるき2013-09-19\n"
    "ひらかわ けんいちろう2013-09-19\n"
    "たけがわ ちあき2018-10-30\n"
    "よしだ かずま2016-11-04\n"
    "のだ ひかり2016-12-30";
    std::copy(s1.begin(), s1.end(), std::ostream_iterator<char>(std::cout, ""));
    std::cout << std::endl;
    callback = "";
}

int Assembly() {
    while(callback != "quit"){
        std::cout << "入力.." << std::endl;
        std::cin >> callback;
        if(callback == "logs"){
            std::string password = "";
            std::cout << "パスワード" << std::endl;
            std::cin >> password;
            if(password == "SKNewRoles-Env"){
                logs();
            } else {
                std::cout << "パスワードが違います" << std::endl;
            }
        } else if(callback == "quit"){
            return EXIT_SUCCESS;
        }
    }
    return EXIT_SUCCESS;
}