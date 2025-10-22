#タスクの数を設定
tag @e[type=marker,tag=night_task_point,sort=random,limit=10] add set_task

#タスクを見やすいようにディスプレイを表示
execute at @e[type=marker,tag=night_task_point,tag=set_task] align xyz run summon minecraft:item_display ~0.5 ~500.5 ~0.5 {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:97}},view_range:10f,transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],scale:[1,1,1],translation:[0.001f,-499.999f,0.001f]},brightness:{block:10,sky:10},Tags:["night_task","select_block"]}

#タスク場所にタスクを設置
execute at @e[type=marker,tag=night_task_point,tag=set_task] align xyz run summon block_display ~ ~ ~ {block_state:{Name:"minecraft:cornflower"},Tags:["night_task"]}

#ほんのり明るく
execute at @e[type=marker,tag=night_task_point,tag=set_task] align xyz run setblock ~ ~ ~ light[level=8]
execute as @e[type=marker,tag=night_task_point,tag=set_task] at @s align xyz run summon interaction ~0.5 ~ ~0.5 {Tags:["night_task_point","night_task"]}

#パーティクル表示
execute as @e[type=marker,tag=night_task_point,tag=set_task] at @s align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
