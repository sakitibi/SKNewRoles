scoreboard players set @s aj.treasure_chest.animation.open.local_anim_time 0
tag @s remove aj.treasure_chest.animation.open
execute on passengers run data modify entity @s interpolation_duration set value 0
tag @s add aj.treasure_chest.disable_command_keyframes
function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/animations/open/tree/leaf_0
tag @s remove aj.treasure_chest.disable_command_keyframes