#include <iostream>
#include <vector>
#include <algorithm>
#include <random>
#include <cmath>

struct Entity {
    std::string team;
    std::string type;
    std::vector<std::string> tags;
    double x, y, z; // Position for distance calculations
};

// Function to calculate distance between two entities
double distance(const Entity& a, const Entity& b) {
    return std::sqrt(std::pow(a.x - b.x, 2) + std::pow(a.y - b.y, 2) + std::pow(a.z - b.z, 2));
}

int main() {
    std::vector<Entity> armorStands = { /* List of armor stands with positions */ };
    std::vector<Entity> players = { /* List of players with positions */ };
    int roleCount = 1; // Assume 1 for this example (should be dynamically set)
    
    // Random selection of armor stands
    std::random_device rd;
    std::mt19937 g(rd());
    std::shuffle(armorStands.begin(), armorStands.end(), g);
    
    std::vector<Entity> selected;
    for (size_t i = 0; i < std::min(static_cast<size_t>(roleCount), armorStands.size()); ++i) {
        armorStands[i].tags.push_back("selected");
        selected.push_back(armorStands[i]);
    }
    
    // Assign nearest player to "Asasine" team
    for (auto& stand : selected) {
        Entity* nearestPlayer = nullptr;
        double minDistance = std::numeric_limits<double>::max();
        
        for (auto& player : players) {
            if (player.team == "Mura") {
                double dist = distance(stand, player);
                if (dist < minDistance) {
                    minDistance = dist;
                    nearestPlayer = &player;
                }
            }
        }
        
        if (nearestPlayer) {
            nearestPlayer->team = "Asasine";
            nearestPlayer->tags.push_back("team_asasine");
            nearestPlayer->tags.push_back("camp_red");
        }
    }
    
    // Remove used armor stands
    armorStands.erase(std::remove_if(armorStands.begin(), armorStands.end(), [](const Entity& e) {
        return std::find(e.tags.begin(), e.tags.end(), "selected") != e.tags.end();
    }), armorStands.end());
    
    // Print results (for debug purposes)
    for (const auto& player : players) {
        std::cout << "Player on team: " << player.team << "\n";
    }
    
    return 0;
}
