#s
#Makerを設置
execute if entity @s[y_rotation=-45..44.9] align xyz unless entity @e[type=marker,tag=check_slab_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["check_slab_point","south"]}
#w
execute if entity @s[y_rotation=45..134.9] align xyz unless entity @e[type=marker,tag=check_slab_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["check_slab_point","west"]}
#n
execute if entity @s[y_rotation=135..224.9] align xyz unless entity @e[type=marker,tag=check_slab_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["check_slab_point","north"]}
#e
execute if entity @s[y_rotation=225..314.9] align xyz unless entity @e[type=marker,tag=check_slab_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["check_slab_point","east"]}

#s
execute at @e[type=marker,tag=check_slab_point,tag=south] run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:100}},Tags:["check_slab"],Rotation:[0f,0f]}
#w
execute at @e[type=marker,tag=check_slab_point,tag=west] run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:100}},Tags:["check_slab"],Rotation:[90f,0f]}
#n
execute at @e[type=marker,tag=check_slab_point,tag=north] run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:100}},Tags:["check_slab"],Rotation:[180f,0f]}
#e
execute at @e[type=marker,tag=check_slab_point,tag=east] run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:100}},Tags:["check_slab"],Rotation:[270f,0f]}

execute at @e[type=marker,tag=check_slab_point] align xyz run summon interaction ~0.5 ~ ~0.5 {Tags:["check_slab"],height:1.6f}

kill @e[type=marker,tag=check_slab_point,distance=..0.5]

#おかたづけ
#kill @e[type=item_display,tag=check_slab]
