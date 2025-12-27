#execute as @e[type=marker,tag=treasure_chest] at @s unless entity @e[type=block_display,tag=treasure_chest,distance=..1] run summon block_display ~ ~ ~ {block_state:{Name:"minecraft:chest"},Tags:["treasure_chest"]}
#ランダムにチェストを選ぶ
tag @e[type=marker,tag=treasure_chest_place,sort=random,limit=5] add active_treasure_chest

#execute as @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] at @s unless entity @e[type=item_display,tag=treasure_chest,distance=..1] run summon minecraft:item_display ~ ~0.5 ~ {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:103}},Tags:["treasure_chest"]}
#execute as @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] at @s unless entity @e[type=interaction,tag=treasure_chest,distance=..1] run summon minecraft:interaction ~ ~ ~ {Tags:["treasure_chest"],width:0.6f,height:0.6f}
#execute as @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] at @s run data modify entity @e[type=item_display,tag=treasure_chest,limit=1,sort=nearest] Rotation[0] set from entity @s Rotation[0]

#animated_java用
execute as @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] at @s unless entity @e[type=item_display,tag=treasure_chest,distance=..1] run function Adv_Map_Creator_data:animated_java/treasure_chest/summon
execute as @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] at @s unless entity @e[type=interaction,tag=treasure_chest,distance=..1] run summon minecraft:interaction ~ ~ ~ {Tags:["treasure_chest"],width:0.6f,height:0.6f}
execute as @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] at @s run data modify entity @e[type=#Adv_Map_Creator_data:animated_java/root,tag=aj.treasure_chest.root,limit=1,sort=nearest] Rotation[0] set from entity @s Rotation[0]