#include <iostream>
#include <thread>
#include <chrono>

int main() {
    if (analytics.set_value()) {
        std::cout << "[Init] Analytics enabled. Scheduling exec in 5 seconds..." << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(5));
        std::cout << "[Init] Running sknewrolesanalytics::exec" << std::endl;
        // Here you would call the exec logic, e.g., exec();
    } else {
        std::cout << "[Init] Analytics not enabled." << std::endl;
    }
    return 0;
}