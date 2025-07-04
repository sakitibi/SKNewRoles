#include <iostream>
#include <string>


void applyDamage(const std::string& target, double amount, const std::string& damageType, const std::string& source) {
    std::cout << "Applying " << amount << " damage of type " << damageType << " to " << target << " by " << source << std::endl;
}

void executeFunction(const std::string& functionName) {
    std::cout << "Executing function " << functionName << std::endl;
}

int main() {
    
    std::string entity = "@s"; 
    std::string target = "@a[tag=7,limit=1]"; 
    std::string team = "Jinrou"; 

    // Jinrou
    if (team == "Jinrou") {
        applyDamage(target, 0.01, "fall", entity);
        executeFunction("werewolf:.system/player_attacked/sword_effect");
    }

    // Ponkotsu
    if (team == "Ponkotsu") {
        applyDamage(target, 1, "fall", "");
        executeFunction("werewolf:.system/player_attacked/sword_effect_dummy");
    }

    // Asasine
    if (team == "Asasine") {
        applyDamage(target, 0.01, "fall", entity);
        executeFunction("werewolf:.system/player_attacked/sword_effect");
    }

    return 0;
}
