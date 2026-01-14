scoreboard players set @s aj.windmill.animation.rotation.local_anim_time 0
tag @s remove aj.windmill.animation.rotation
execute on passengers run data modify entity @s interpolation_duration set value 0
tag @s add aj.windmill.disable_command_keyframes
function Adv_Map_Creator_data:animated_java/windmill/zzzzzzzz/animations/rotation/tree/leaf_0
tag @s remove aj.windmill.disable_command_keyframes