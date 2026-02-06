execute unless score @s aj.fake_wall.rig_loaded = @s aj.fake_wall.rig_loaded run function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/on_load
scoreboard players add @s aj.life_time 1
execute at @s on passengers run tp @s ~ ~ ~ ~ ~
function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/tick
function #Adv_Map_Creator_data:animated_java/fake_wall/on_tick/as_root