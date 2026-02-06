scoreboard players set @s aj.anim_time 0
scoreboard players set @s aj.fake_wall.animation.open.local_anim_time 0
scoreboard players set @s aj.fake_wall.animation.open.loop_mode 2
execute on passengers run data modify entity @s interpolation_duration set value 0
function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/open/tree/leaf_0
execute on passengers run data modify entity @s interpolation_duration set value 1
tag @s add aj.fake_wall.animation.open