scoreboard players set @s aj.pitfall.animation.genarate.local_anim_time 0
tag @s remove aj.pitfall.animation.genarate
execute on passengers run data modify entity @s interpolation_duration set value 0
tag @s add aj.pitfall.disable_command_keyframes
function Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/animations/genarate/tree/leaf_0
tag @s remove aj.pitfall.disable_command_keyframes