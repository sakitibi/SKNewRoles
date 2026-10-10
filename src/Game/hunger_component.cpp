#include "hunger_component.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void HungerComponent::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_max_hunger"), &HungerComponent::get_max_hunger);
    ClassDB::bind_method(D_METHOD("set_max_hunger", "p_hunger"), &HungerComponent::set_max_hunger);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "max_hunger"), "set_max_hunger", "get_max_hunger");

    ClassDB::bind_method(D_METHOD("get_current_hunger"), &HungerComponent::get_current_hunger);
    ClassDB::bind_method(D_METHOD("set_current_hunger", "p_hunger"), &HungerComponent::set_current_hunger);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "current_hunger"), "set_current_hunger", "get_current_hunger");

    ClassDB::bind_method(D_METHOD("consume_hunger", "amount"), &HungerComponent::consume_hunger);
    ClassDB::bind_method(D_METHOD("restore_hunger", "amount"), &HungerComponent::restore_hunger);

    ADD_SIGNAL(MethodInfo("hunger_changed", PropertyInfo(Variant::INT, "current_hunger"), PropertyInfo(Variant::INT, "max_hunger")));
}

HungerComponent::HungerComponent() {}
HungerComponent::~HungerComponent() {}

void HungerComponent::set_max_hunger(int p_hunger) {
    max_hunger = p_hunger;
}

int HungerComponent::get_max_hunger() const {
    return max_hunger;
}

void HungerComponent::set_current_hunger(int p_hunger) {
    current_hunger = Math::clamp(p_hunger, 0, max_hunger);
    emit_signal("hunger_changed", current_hunger, max_hunger);
}

int HungerComponent::get_current_hunger() const {
    return current_hunger;
}

void HungerComponent::consume_hunger(int amount) {
    set_current_hunger(current_hunger - amount);
}

void HungerComponent::restore_hunger(int amount) {
    set_current_hunger(current_hunger + amount);
}