scoreboard players set @s aj.fake_wall.animation.open.local_anim_time 0
tag @s remove aj.fake_wall.animation.open
execute on passengers run data modify entity @s interpolation_duration set value 0
tag @s add aj.fake_wall.disable_command_keyframes
function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/open/tree/leaf_0
tag @s remove aj.fake_wall.disable_command_keyframes