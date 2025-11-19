# 削除演出
execute at @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] run particle minecraft:cloud ~ ~0.5 ~ 0.5 0.5 0.5 0 3 force @a

# 削除
kill @e[tag=treasure_chest]
tag @e[type=marker,tag=treasure_chest_place,tag=active_treasure_chest] remove active_treasure_chest
function Adv_Map_Creator_data:animated_java/treasure_chest/remove/all