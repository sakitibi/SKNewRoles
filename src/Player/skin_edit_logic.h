#pragma once

#include <string>
#include <vector>
#include <map>

class SkinEditLogic {
    private:
        std::vector<std::string> available_presets;
        std::map<std::string, std::string> equipped_presets;
        float rotate_sensitivity;

    public:
        SkinEditLogic();
        ~SkinEditLogic() = default;

        void add_available_preset(const std::string &preset_id);
        void set_preset_for_part(const std::string &part_name, const std::string &preset_id);
        std::string get_preset_for_part(const std::string &part_name) const;

        void select_preset_for_all(const std::string &preset_id);
        std::string cycle_part_preset(const std::string &part_name);

        const std::map<std::string, std::string>& get_equipped_presets() const;
        void set_equipped_presets(const std::map<std::string, std::string> &presets);

        void set_rotate_sensitivity(float val);
        float get_rotate_sensitivity() const;
};