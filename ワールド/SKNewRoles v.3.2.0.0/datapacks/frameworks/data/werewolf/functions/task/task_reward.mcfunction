execute as @a[scores={mined.oak_log=1..}] run give @s emerald
execute as @a[scores={mined.iron_ore=1..}] run give @s emerald
#execute as @a[scores={mined.wheat=1..}] run give @s wheat
#execute as @a[scores={mined.red_mushroom=1..}] run give @s red_mushroom
#execute as @a[scores={mined.brown_mushroom=1..}] run give @s brown_mushroom


scoreboard players set @a mined.oak_log 0
scoreboard players set @a mined.iron_ore 0
#scoreboard players set @a mined.wheat 0
#scoreboard players set @a mined.red_mushroom 0
#scoreboard players set @a mined.brown_mushroom 0
