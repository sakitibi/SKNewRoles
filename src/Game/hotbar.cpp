#include "hotbar.h"
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

void Hotbar::_bind_methods() {
    // メソッドのバインド
    ClassDB::bind_method(D_METHOD("select_slot", "index"), &Hotbar::select_slot);
    ClassDB::bind_method(D_METHOD("get_selected_slot"), &Hotbar::get_selected_slot);
    ClassDB::bind_method(D_METHOD("set_slot_item", "index", "item_id", "count"), &Hotbar::set_slot_item);
    ClassDB::bind_method(D_METHOD("get_slot_item", "index"), &Hotbar::get_slot_item);
    ClassDB::bind_method(D_METHOD("add_item", "item_id", "count"), &Hotbar::add_item, DEFVAL(1));
    ClassDB::bind_method(D_METHOD("consume_item", "index", "amount"), &Hotbar::consume_item, DEFVAL(1));

    // シグナルの定義
    ADD_SIGNAL(MethodInfo("slot_changed", PropertyInfo(Variant::INT, "new_index")));
    ADD_SIGNAL(MethodInfo("item_changed", PropertyInfo(Variant::INT, "slot_index"), PropertyInfo(Variant::INT, "item_id"), PropertyInfo(Variant::INT, "count")));
}

Hotbar::Hotbar() {
    // 初期化（全スロットを空に設定）
    for (auto& slot : slots_) {
        slot.item_id = 0;
        slot.count = 0;
    }
}

Hotbar::~Hotbar() {}

void Hotbar::select_slot(int index) {
    if (index < 0 || index >= 9) return;

    if (selected_index_ != index) {
        selected_index_ = index;
        emit_signal("slot_changed", selected_index_);
    }
}

int Hotbar::get_selected_slot() const {
    return selected_index_;
}

void Hotbar::set_slot_item(int index, int item_id, int count) {
    if (index < 0 || index >= 9) return;

    slots_[index].item_id = item_id;
    slots_[index].count = count;

    emit_signal("item_changed", index, item_id, count);
}

Dictionary Hotbar::get_slot_item(int index) const {
    Dictionary result;
    if (index < 0 || index >= 9) {
        result["item_id"] = 0;
        result["count"] = 0;
        return result;
    }

    result["item_id"] = slots_[index].item_id;
    result["count"] = slots_[index].count;
    return result;
}

bool Hotbar::add_item(int item_id, int count) {
    if (item_id <= 0 || count <= 0) return false;

    // 既存の同じアイテムが存在するスロットへ加算
    for (int i = 0; i < 9; ++i) {
        if (slots_[i].item_id == item_id) {
            slots_[i].count += count;
            emit_signal("item_changed", i, slots_[i].item_id, slots_[i].count);
            return true;
        }
    }

    for (int i = 0; i < 9; ++i) {
        if (slots_[i].item_id == 0) {
            slots_[i].item_id = item_id;
            slots_[i].count = count;
            emit_signal("item_changed", i, slots_[i].item_id, slots_[i].count);
            return true;
        }
    }

    // ホットバーが満杯の場合
    return false;
}

bool Hotbar::consume_item(int index, int amount) {
    if (index < 0 || index >= 9) return false;
    if (slots_[index].item_id == 0 || slots_[index].count < amount) return false;

    slots_[index].count -= amount;
    if (slots_[index].count <= 0) {
        slots_[index].item_id = 0;
        slots_[index].count = 0;
    }

    emit_signal("item_changed", index, slots_[index].item_id, slots_[index].count);
    return true;
}