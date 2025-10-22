scoreboard players add @s aj.treasure_chest.animation.open.local_anim_time 1
scoreboard players operation @s aj.anim_time = @s aj.treasure_chest.animation.open.local_anim_time
function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/animations/open/apply_frame_as_root
execute if score @s aj.treasure_chest.animation.open.local_anim_time matches 10.. run function Adv_Map_Creator_data:animated_java/treasure_chest/zzzzzzzz/animations/open/end