#タスク報酬
    function werewolf:task/task_reward
#消化済みタスク削除
    execute align xyz as @e[type=marker,tag=oak_log,tag=set_task] at @s unless block ~ ~ ~ minecraft:oak_log positioned ~0.5 ~500.5 ~0.5 run kill @e[type=item_display,tag=select_block,distance=..0.5]
    execute align xyz as @e[type=marker,tag=iron_ore,tag=set_task] at @s unless block ~ ~ ~ minecraft:iron_ore positioned ~0.5 ~500.5 ~0.5 run kill @e[type=item_display,tag=select_block,distance=..0.5]
#タスク用のinteraction処理
    execute as @e[type=minecraft:interaction,tag=task_point] at @s if data entity @s attack.player run function werewolf:task/kill_interaction_task
    execute as @e[type=minecraft:interaction,tag=night_task_point] at @s if data entity @s attack.player run function werewolf:task/night_task/kill_interaction_night_task
#タスクを破壊可能にする処理
execute as @a[scores={can_mining=1..}] run scoreboard players remove @s can_mining 1
execute as @a[scores={can_mining=0}] if data entity @s SelectedItem{id:"minecraft:iron_pickaxe"} unless data entity @s SelectedItem.tag{CanDestroy:[""]} run item modify entity @s weapon.mainhand werewolf:item/tool/remove_can_destroy
execute as @a[scores={can_mining=0}] if data entity @s SelectedItem{id:"minecraft:iron_axe"} unless data entity @s SelectedItem.tag{CanDestroy:[""]} run item modify entity @s weapon.mainhand werewolf:item/tool/remove_can_destroy
execute as @e[type=interaction,tag=ser] if data entity @s attack.player run function werewolf:task/.on_switcher_task
execute as @e[type=interaction,tag=ser,scores={can_mining=1..}] run scoreboard players remove @s can_mining 1
execute as @e[type=interaction,tag=switcher,scores={can_mining=0}] run function werewolf:task/.off_switcher
execute as @e[type=interaction,tag=switcher] at @s if block ~ ~1 ~ air run kill @s
#夜のタスクにパーティクルを付与
execute if data storage sys: {time_phase:night} as @e[type=marker,tag=night_task_point,tag=set_task] at @s if entity @e[type=interaction,tag=night_task,distance=..1] align xyz run particle minecraft:crit ~0.5 ~0.5 ~0.5 0.3 0.3 0.3 0 1 force @a