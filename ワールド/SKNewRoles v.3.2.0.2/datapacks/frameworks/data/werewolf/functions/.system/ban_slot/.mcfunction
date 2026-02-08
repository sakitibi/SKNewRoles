# スロット情報記録
schedule function werewolf:.system/ban_slot/slot_saved 1t append false
# Slot情報削除
data remove storage sys: return_item[].Slot

# シュルカーボックス設置
setblock 0 0 0 minecraft:shulker_box
# シュルカーボックスにアイテム格納
data modify block 0 0 0 Items set from storage sys: return_item
# アイテムドロップ
execute as @s at @s run loot spawn ~ ~ ~ mine 0 0 0 minecraft:debug_stick
# シュルカーボックス削除
setblock 0 0 0 minecraft:air
# 念のためのストレージリセット
data remove storage sys: return_item

clear @s barrier{Tags:["ban_slot","no_drop"]}

# メインの処理
schedule function werewolf:.system/ban_slot/main 1t append false