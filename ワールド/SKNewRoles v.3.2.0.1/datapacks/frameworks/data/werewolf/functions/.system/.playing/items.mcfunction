#見本アイテムを所持していたら実物と交換
    execute as @a[predicate=werewolf:have_item/sample] run function werewolf:shop/.shop_item_exchange
#空瓶を削除
    execute as @a[predicate=werewolf:have_item/glass_bottle_mainhand] run item replace entity @s weapon.mainhand with air
    execute as @a[predicate=werewolf:have_item/glass_bottle_offhand] run item replace entity @s weapon.offhand with air
#右クリック系アイテム処理
    execute as @a[predicate=werewolf:have_item/blindness_tool,scores={right_click=1..}] run function werewolf:item/blindness_tool/blindness_tool
    execute as @a[predicate=werewolf:have_item/same_look_tool,scores={right_click=1..}] run function werewolf:item/same_look_tool/same_look_tool
    execute as @a[predicate=werewolf:have_item/glowing_tool,scores={right_click=1..}] run function werewolf:item/glowing_tool
    execute as @a[predicate=werewolf:have_item/teleport_tool,scores={right_click=1..}] run function werewolf:item/teleport_tool/1
#弓の射線をわかりやすく
    execute at @e[type=arrow] run particle minecraft:end_rod ~ ~ ~ 0.001 0.001 0.001 0 1 force @a
#通常剣のクールタイム処理
    execute as @a[scores={swords_cooltime=1..}] run scoreboard players remove @s swords_cooltime 1
    execute as @a[scores={swords_cooltime=0},predicate=werewolf:have_item/nomal_sword_cooltime] run loot replace entity @s weapon.mainhand loot werewolf:item/weapon/nomal_sword/
    execute as @a[scores={swords_cooltime=0},predicate=werewolf:have_item/strong_sword_cooltime] run loot replace entity @s weapon.mainhand loot werewolf:item/weapon/strong_sword/
#武器を手に持った時に攻撃力を限りなく下げる
    execute as @a[predicate=werewolf:have_item/have_weapon] run attribute @s minecraft:generic.attack_damage base set 0.00001
    execute as @a[predicate=!werewolf:have_item/have_weapon] run attribute @s minecraft:generic.attack_damage base set 1.0

#矢ダメージを調整
    #execute as @e[type=minecraft:arrow] run data modify entity @s damage set value 2
#撃った弓矢を拾えないように
    execute as @e[type=arrow] if entity @s run data modify entity @s life set value 1200