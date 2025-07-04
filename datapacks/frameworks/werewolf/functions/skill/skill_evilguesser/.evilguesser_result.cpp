#include <iostream>
#include <string>

int main() {
    if (skill_evilguesser_cooltime != 0) {
        std::cout << "今はまだ使えない。" << std::endl;
        return 0;
    }

    for (tag <= 13; ++tag) {
        std::cout << "[Skill] Executing evilguesser_skill/particular/evilguesser_" << tag << std::endl;
    }

    if (team == "Evilguesser" && skill_evilguesser_cooltime == 0) {
        std::cout << "[Loot] Replace mainhand weapon with cooltime loot." << std::endl;
    }

    if (skill_evilguesser_cooltime == 0) {
        --skill_evilguesser_limit;
        std::cout << "[Usage] skill_evilguesser_limit decreased to " << skill_evilguesser_limit << std::endl;
    }

    if (skill_evilguesser_cooltime == 0) {
        skill_evilguesser_frequency = 1;
        std::cout << "[Frequency] skill_evilguesser_frequency reset to " << skill_evilguesser_frequency << std::endl;
    }

    if (skill_evilguesser_cooltime == 0) {
        ++skill_evilguesser_cooltime;
        std::cout << "[Cooldown] skill_evilguesser_cooltime increased to " << skill_evilguesser_cooltime << std::endl;
    }

    return 0;
}
