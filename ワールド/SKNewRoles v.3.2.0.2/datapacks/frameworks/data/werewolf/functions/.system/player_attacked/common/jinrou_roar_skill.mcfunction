#騎士の護り処理
# メインハンドのアイテム保存
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1}] run data modify storage sys: return_item set from entity @s Inventory[{Slot:-106b}]
# Slot情報削除
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1}] run data remove storage sys: return_item.Slot
# シュルカーボックス設置
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1}] run setblock 0 0 0 minecraft:shulker_box
# アイテムの情報書き換え
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1}] run data modify block 0 0 0 Items append from storage sys: return_item
# トーテムをメインハンドに
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1}] run item replace entity @s weapon.offhand with totem_of_undying{Tags:["kishi_totem"]}

# ダメージ処理
damage @s[team=!Youko] 50 minecraft:fall

# 元のアイテムを書き戻し
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1..}] run loot replace entity @s weapon.offhand 1 mine 0 0 0 minecraft:debug_stick
# シュルカーボックス削除
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1..}] run setblock 0 0 0 minecraft:air
# アイテムデータ削除
execute if entity @a[team=Kishi] as @s[team=!Youko,scores={skill_kishi_protected=1..}] run data remove storage sys: return_item

advancement revoke @s only werewolf:player_damaged/common/jinrou_roar_skill