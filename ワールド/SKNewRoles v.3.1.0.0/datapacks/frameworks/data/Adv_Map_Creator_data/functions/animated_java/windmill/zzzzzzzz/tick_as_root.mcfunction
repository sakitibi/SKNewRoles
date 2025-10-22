execute unless score @s aj.windmill.rig_loaded = @s aj.windmill.rig_loaded run function Adv_Map_Creator_data:animated_java/windmill/zzzzzzzz/on_load
scoreboard players add @s aj.life_time 1
execute at @s on passengers run tp @s ~ ~ ~ ~ ~
function Adv_Map_Creator_data:animated_java/windmill/zzzzzzzz/animations/tick
function #Adv_Map_Creator_data:animated_java/windmill/on_tick/as_root