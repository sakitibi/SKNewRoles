scoreboard players set @s aj.anim_time 0
scoreboard players set @s aj.treasure_chest.animation.open.local_anim_time 0
scoreboard players set @s aj.treasure_chest.animation.open.loop_mode 2
execute on passengers run data modify entity @s interpolation_duration set value 0
function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/animations/open/tree/leaf_0
execute on passengers run data modify entity @s interpolation_duration set value 1
tag @s add aj.treasure_chest.animation.open