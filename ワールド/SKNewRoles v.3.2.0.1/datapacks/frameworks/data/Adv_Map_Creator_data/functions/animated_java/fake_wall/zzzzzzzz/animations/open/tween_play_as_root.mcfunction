function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/open/play_as_root
function Adv_Map_Creator_data:animated_java/fake_wall/zzzzzzzz/animations/open/tween_as_root
execute if score #tween_duration aj.i matches ..0 on passengers run data modify entity @s interpolation_duration set value 1
scoreboard players reset #tween_duration aj.i