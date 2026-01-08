scoreboard players add @s aj.pitfall.animation.genarate.local_anim_time 1
scoreboard players operation @s aj.anim_time = @s aj.pitfall.animation.genarate.local_anim_time
function Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/animations/genarate/apply_frame_as_root
execute if score @s aj.pitfall.animation.genarate.local_anim_time matches 120.. run function Adv_Map_Creator_data:animated_java/pitfall/zzzzzzzz/animations/genarate/end