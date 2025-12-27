#タスクをリセット
execute at @e[type=marker,tag=task_point] run setblock ~ ~ ~ air
kill @e[type=item_display,tag=no_task]
kill @e[type=block_display,tag=no_task]
kill @e[type=item_display,tag=select_block]
kill @e[type=interaction,tag=task_point]
kill @e[type=interaction,tag=switcher]
tag @e[type=marker,tag=task_point,tag=set_task] remove set_task
#タスクの数を設定
#人数に応じる場合
    #少人数
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:0} run tag @e[type=marker,tag=task_point,tag=oak_log,sort=random,limit=13] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:0} run tag @e[type=marker,tag=task_point,tag=iron_ore,sort=random,limit=13] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:0} run tag @e[type=marker,tag=task_point,tag=wheat,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:0} run tag @e[type=marker,tag=task_point,tag=red_mushroom,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:0} run tag @e[type=marker,tag=task_point,tag=brown_mushroom,sort=random,limit=15] add set_task
    #デフォルト
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:1} run tag @e[type=marker,tag=task_point,tag=oak_log,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:1} run tag @e[type=marker,tag=task_point,tag=iron_ore,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:1} run tag @e[type=marker,tag=task_point,tag=wheat,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:1} run tag @e[type=marker,tag=task_point,tag=red_mushroom,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:1} run tag @e[type=marker,tag=task_point,tag=brown_mushroom,sort=random,limit=15] add set_task
    #大人数
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:2} run tag @e[type=marker,tag=task_point,tag=oak_log,sort=random,limit=22] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:2} run tag @e[type=marker,tag=task_point,tag=iron_ore,sort=random,limit=22] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:2} run tag @e[type=marker,tag=task_point,tag=wheat,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:2} run tag @e[type=marker,tag=task_point,tag=red_mushroom,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:9} if data storage sys: {task_count:2} run tag @e[type=marker,tag=task_point,tag=brown_mushroom,sort=random,limit=15] add set_task
#設定されている場合
    #少人数
    execute if data storage sys: {task_mode:0} run tag @e[type=marker,tag=task_point,tag=oak_log,sort=random,limit=13] add set_task
    execute if data storage sys: {task_mode:0} run tag @e[type=marker,tag=task_point,tag=iron_ore,sort=random,limit=13] add set_task
    execute if data storage sys: {task_mode:0} run tag @e[type=marker,tag=task_point,tag=wheat,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:0} run tag @e[type=marker,tag=task_point,tag=red_mushroom,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:0} run tag @e[type=marker,tag=task_point,tag=brown_mushroom,sort=random,limit=15] add set_task
    #デフォルト
    execute if data storage sys: {task_mode:1} run tag @e[type=marker,tag=task_point,tag=oak_log,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:1} run tag @e[type=marker,tag=task_point,tag=iron_ore,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:1} run tag @e[type=marker,tag=task_point,tag=wheat,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:1} run tag @e[type=marker,tag=task_point,tag=red_mushroom,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:1} run tag @e[type=marker,tag=task_point,tag=brown_mushroom,sort=random,limit=15] add set_task
    #大人数
    execute if data storage sys: {task_mode:2} run tag @e[type=marker,tag=task_point,tag=oak_log,sort=random,limit=22] add set_task
    execute if data storage sys: {task_mode:2} run tag @e[type=marker,tag=task_point,tag=iron_ore,sort=random,limit=22] add set_task
    execute if data storage sys: {task_mode:2} run tag @e[type=marker,tag=task_point,tag=wheat,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:2} run tag @e[type=marker,tag=task_point,tag=red_mushroom,sort=random,limit=15] add set_task
    execute if data storage sys: {task_mode:2} run tag @e[type=marker,tag=task_point,tag=brown_mushroom,sort=random,limit=15] add set_task

#タスク場所の抽選漏れを処理
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=oak_log] run setblock ~ ~ ~ barrier
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=iron_ore] run setblock ~ ~ ~ barrier
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=oak_log] align xyz run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"minecraft:oak_log",Count:1b},Tags:["no_task"]}
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=iron_ore] align xyz run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"minecraft:stone",Count:1b},Tags:["no_task"]}
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=wheat] align xyz run summon block_display ~ ~ ~ {block_state:{Name:"minecraft:wheat",Properties:{age:"7"}},Tags:["no_task"]}
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=red_mushroom] align xyz run summon block_display ~ ~ ~ {block_state:{Name:"minecraft:red_mushroom"},Tags:["no_task"]}
execute at @e[type=marker,tag=task_point,tag=!set_task,tag=brown_mushroom] align xyz run summon block_display ~ ~ ~ {block_state:{Name:"minecraft:brown_mushroom"},Tags:["no_task"]}
#タスクを見やすいようにディスプレイを表示
execute at @e[type=marker,tag=task_point,tag=size_normal,tag=set_task] align xyz run summon minecraft:item_display ~0.5 ~500.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:98}},view_range:10f,transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],scale:[1,1,1],translation:[0.001f,-499.999f,0.001f]},brightness:{block:10,sky:10},Tags:["select_block"]}
execute at @e[type=marker,tag=task_point,tag=size_small,tag=set_task] align xyz run summon minecraft:item_display ~0.5 ~500.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:97}},view_range:10f,transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],scale:[1,1,1],translation:[0.001f,-499.999f,0.001f]},brightness:{block:10,sky:10},Tags:["select_block"]}
#タスク場所にタスクを設置
execute as @e[type=marker,tag=oak_log,tag=set_task] at @s unless block ~ ~ ~ minecraft:oak_log run setblock ~ ~ ~ minecraft:oak_log
execute as @e[type=marker,tag=iron_ore,tag=set_task] at @s unless block ~ ~ ~ minecraft:iron_ore run setblock ~ ~ ~ minecraft:iron_ore
execute as @e[type=marker,tag=red_mushroom,tag=set_task] at @s unless block ~ ~ ~ minecraft:red_mushroom run setblock ~ ~ ~ minecraft:red_mushroom
execute as @e[type=marker,tag=brown_mushroom,tag=set_task] at @s unless block ~ ~ ~ minecraft:brown_mushroom run setblock ~ ~ ~ minecraft:brown_mushroom
execute as @e[type=marker,tag=wheat,tag=set_task] at @s unless block ~ ~ ~ minecraft:wheat run setblock ~ ~ ~ wheat[age=7]

execute align xyz as @e[type=marker,tag=red_mushroom,tag=set_task] at @s run summon interaction ~0.5 ~ ~0.5 {Tags:["task_point"]}
execute align xyz as @e[type=marker,tag=brown_mushroom,tag=set_task] at @s run summon interaction ~0.5 ~ ~0.5 {Tags:["task_point"]}
execute align xyz as @e[type=marker,tag=wheat,tag=set_task] at @s run summon interaction ~0.5 ~ ~0.5 {Tags:["task_point"],width:1.1f,height:1.1f}

#スイッチャーを設置
execute align xyz as @e[type=marker,tag=oak_log,tag=set_task] at @s positioned ~0.5 ~-0.0001 ~0.5 run summon interaction ~ ~ ~ {Tags:["switcher"],width:1.001f,height:1.001f}
execute align xyz as @e[type=marker,tag=iron_ore,tag=set_task] at @s positioned ~0.5 ~-0.0001 ~0.5 run summon interaction ~ ~ ~ {Tags:["switcher"],width:1.001f,height:1.001f}

#パーティクル表示
execute align xyz as @e[type=marker,tag=set_task] at @s run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a