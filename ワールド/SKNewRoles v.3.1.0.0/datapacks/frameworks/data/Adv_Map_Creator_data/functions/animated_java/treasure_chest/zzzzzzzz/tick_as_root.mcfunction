execute unless score @s aj.treasure_chest.rig_loaded = @s aj.treasure_chest.rig_loaded run function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/on_load
scoreboard players add @s aj.life_time 1
execute at @s on passengers run tp @s ~ ~ ~ ~ ~
function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/animations/tick
function #Adv_Map_Creator_data:animated_java/treasure_chest/on_tick/as_root