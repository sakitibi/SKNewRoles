# Slot情報削除
data remove storage sys: return_item.Slot
# シュルカーボックス設置
setblock 0 0 0 minecraft:shulker_box
# アイテムの情報書き換え
data modify block 0 0 0 Items append from storage sys: return_item
# アイテムドロップ
loot spawn ~ ~ ~ mine 0 0 0 minecraft:debug_stick
# シュルカーボックス削除
setblock 0 0 0 minecraft:air