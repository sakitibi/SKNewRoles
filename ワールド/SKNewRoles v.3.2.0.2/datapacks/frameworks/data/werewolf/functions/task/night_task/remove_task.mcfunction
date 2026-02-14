#パーティクル表示
execute as @e[type=marker,tag=night_task_point,tag=set_task] at @s align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a

#タスクフラグをリセット
tag @e[type=marker,tag=night_task_point] remove set_task

#タスクを削除
execute at @e[type=marker,tag=night_task_point] align xyz run setblock ~ ~ ~ air
kill @e[tag=night_task]