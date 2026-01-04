scoreboard players add @s aj.windmill.animation.rotation.local_anim_time 1
scoreboard players operation @s aj.anim_time = @s aj.windmill.animation.rotation.local_anim_time
function Adv_Map_Creator_data:animated_java/windmill/zzzzzzzz/animations/rotation/apply_frame_as_root
execute if score @s aj.windmill.animation.rotation.local_anim_time matches 1280.. run function Adv_Map_Creator_data:animated_java/windmill/zzzzzzzz/animations/rotation/end