# スロット情報記録
data modify storage sys: return_item set from entity @s Inventory[{Slot:7b}]
# アイテム返却
execute as @s at @s run function werewolf:.system/inventory_menu/return_item
# 念のためのストレージリセット
data remove storage sys: return_item

# 役職本クリア
clear @s written_book{Tags:["role_book","no_drop"]}

# 本を設置
schedule function werewolf:role/.set_role_book/mura 1t append false
schedule function werewolf:role/.set_role_book/jinrou 1t append false
schedule function werewolf:role/.set_role_book/other 1t append false