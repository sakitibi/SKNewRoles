execute as @s[nbt=!{Inventory:[{id:"minecraft:emerald"}]}] run tellraw @s {"text":"納品するものを持っていない"}
execute as @s[nbt={Inventory:[{id:"minecraft:emerald"}]}] store result storage sys: task_win.progress int 0.99999999 run data get storage sys: task_win.progress
execute as @s[nbt={Inventory:[{id:"minecraft:emerald"}]}] run clear @s emerald 1

advancement revoke @s only werewolf:task_win/interaction_task_win_chest