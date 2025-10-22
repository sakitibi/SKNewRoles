execute unless score @s aj.pitfall.rig_loaded = @s aj.pitfall.rig_loaded run function Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/on_load
scoreboard players add @s aj.life_time 1
execute at @s on passengers run tp @s ~ ~ ~ ~ ~
function Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/animations/tick
function #Adv_Map_Creator_data:animated_java/pitfall/on_tick/as_root