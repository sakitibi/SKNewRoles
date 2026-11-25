#include "skin_edit_logic.h"
#include <algorithm>

SkinEditLogic::SkinEditLogic() {
    available_presets.push_back("preset_1");
    rotate_sensitivity = 0.005f;

    equipped_presets["Head"] = "preset_1";
    equipped_presets["Body"] = "preset_1";
    equipped_presets["RightArm"] = "preset_1";
    equipped_presets["LeftArm"] = "preset_1";
    equipped_presets["RightLeg"] = "preset_1";
    equipped_presets["LeftLeg"] = "preset_1";
}

void SkinEditLogic::add_available_preset(const std::string &preset_id) {
    if (std::find(available_presets.begin(), available_presets.end(), preset_id) == available_presets.end()) {
        available_presets.push_back(preset_id);
    }
}

void SkinEditLogic::set_preset_for_part(const std::string &part_name, const std::string &preset_id) {
    equipped_presets[part_name] = preset_id;
}

std::string SkinEditLogic::get_preset_for_part(const std::string &part_name) const {
    auto it = equipped_presets.find(part_name);
    if (it != equipped_presets.end()) {
        return it->second;
    }
    return "preset_1";
}

void SkinEditLogic::select_preset_for_all(const std::string &preset_id) {
    for (auto &pair : equipped_presets) {
        pair.second = preset_id;
    }
}

std::string SkinEditLogic::cycle_part_preset(const std::string &part_name) {
    std::string current = get_preset_for_part(part_name);

    int current_index = -1;
    for (size_t i = 0; i < available_presets.size(); i++) {
        if (available_presets[i] == current) {
            current_index = static_cast<int>(i);
            break;
        }
    }

    int next_index = (current_index + 1) % static_cast<int>(available_presets.size());
    std::string next_preset = available_presets[next_index];
    equipped_presets[part_name] = next_preset;

    return next_preset;
}

const std::map<std::string, std::string>& SkinEditLogic::get_equipped_presets() const {
    return equipped_presets;
}

void SkinEditLogic::set_equipped_presets(const std::map<std::string, std::string> &presets) {
    equipped_presets = presets;
}

void SkinEditLogic::set_rotate_sensitivity(float val) {
    rotate_sensitivity = val;
}

float SkinEditLogic::get_rotate_sensitivity() const {
    return rotate_sensitivity;
}