#タスク場所にタスクを設置
execute as @e[type=marker,tag=oak_log,tag=set_task] at @s unless block ~ ~ ~ minecraft:oak_log run setblock ~ ~ ~ minecraft:oak_log
execute as @e[type=marker,tag=iron_ore,tag=set_task] at @s unless block ~ ~ ~ minecraft:iron_ore run setblock ~ ~ ~ minecraft:iron_ore
execute as @e[type=marker,tag=red_mushroom,tag=set_task] at @s unless block ~ ~ ~ minecraft:red_mushroom run setblock ~ ~ ~ minecraft:red_mushroom
execute as @e[type=marker,tag=brown_mushroom,tag=set_task] at @s unless block ~ ~ ~ minecraft:brown_mushroom run setblock ~ ~ ~ minecraft:brown_mushroom
execute as @e[type=marker,tag=wheat,tag=set_task] at @s unless block ~ ~ ~ minecraft:wheat run setblock ~ ~ ~ wheat[age=7]

#スイッチャーを設置
execute align xyz as @e[type=marker,tag=oak_log,tag=set_task] at @s positioned ~0.5 ~-0.0001 ~0.5 unless entity @e[type=interaction,tag=switcher,distance=..0.1] run summon interaction ~ ~ ~ {Tags:["switcher"],width:1.001f,height:1.001f}
execute align xyz as @e[type=marker,tag=iron_ore,tag=set_task] at @s positioned ~0.5 ~-0.0001 ~0.5 unless entity @e[type=interaction,tag=switcher,distance=..0.1] run summon interaction ~ ~ ~ {Tags:["switcher"],width:1.001f,height:1.001f}

execute align xyz as @e[type=marker,tag=red_mushroom,tag=set_task] at @s positioned ~0.5 ~ ~0.5 unless entity @e[type=interaction,tag=task_point,distance=..0.1] run summon interaction ~ ~ ~ {Tags:["task_point"]}
execute align xyz as @e[type=marker,tag=brown_mushroom,tag=set_task] at @s positioned ~0.5 ~ ~0.5 unless entity @e[type=interaction,tag=task_point,distance=..0.1] run summon interaction ~ ~ ~ {Tags:["task_point"]}
execute align xyz as @e[type=marker,tag=wheat,tag=set_task] at @s positioned ~0.5 ~ ~0.5 unless entity @e[type=interaction,tag=task_point,distance=..0.1] run summon interaction ~ ~ ~ {Tags:["task_point"],width:1.1f,height:1.1f}

#一旦ディスプレイをキル
kill @e[type=item_display,tag=select_block]
#ディスプレイを表示
execute at @e[type=marker,tag=task_point,tag=size_normal,tag=set_task] align xyz run summon minecraft:item_display ~0.5 ~500.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:98}},view_range:10f,transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],scale:[1,1,1],translation:[0.001f,-499.999f,0.001f]},Tags:["select_block"]}
execute at @e[type=marker,tag=task_point,tag=size_small,tag=set_task] align xyz run summon minecraft:item_display ~0.5 ~500.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:97}},view_range:10f,transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],scale:[1,1,1],translation:[0.001f,-499.999f,0.001f]},Tags:["select_block"]}

#パーティクル表示
execute align xyz as @e[type=marker,tag=set_task] at @s run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a