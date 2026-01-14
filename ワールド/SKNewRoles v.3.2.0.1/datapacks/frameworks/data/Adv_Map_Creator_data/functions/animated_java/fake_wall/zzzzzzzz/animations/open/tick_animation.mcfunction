scoreboard players add @s aj.fake_wall.animation.open.local_anim_time 1
scoreboard players operation @s aj.anim_time = @s aj.fake_wall.animation.open.local_anim_time
function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/open/apply_frame_as_root
execute if score @s aj.fake_wall.animation.open.local_anim_time matches 59.. run function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/open/end