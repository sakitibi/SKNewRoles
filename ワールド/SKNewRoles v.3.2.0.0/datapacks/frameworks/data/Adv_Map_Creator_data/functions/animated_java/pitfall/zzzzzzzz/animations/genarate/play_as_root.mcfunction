scoreboard players set @s aj.anim_time 0
scoreboard players set @s aj.pitfall.animation.genarate.local_anim_time 0
scoreboard players set @s aj.pitfall.animation.genarate.loop_mode 1
execute on passengers run data modify entity @s interpolation_duration set value 0
function Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/animations/genarate/tree/leaf_0
execute on passengers run data modify entity @s interpolation_duration set value 1
tag @s add aj.pitfall.animation.genarate