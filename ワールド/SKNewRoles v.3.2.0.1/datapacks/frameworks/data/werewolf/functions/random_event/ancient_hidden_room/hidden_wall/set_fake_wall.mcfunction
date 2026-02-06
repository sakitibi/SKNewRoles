function Adv_Map_Creator_data:animated_java/fake_wall/remove/all
#animated_java用
execute as @e[type=marker,tag=fake_wall_place] at @s positioned ~0.5 ~ ~0.5 run function Adv_Map_Creator_data:animated_java/fake_wall/summon
execute as @e[type=marker,tag=fake_wall_place] at @s run data modify entity @e[type=#Adv_Map_Creator_data:animated_java/root,tag=aj.fake_wall.root,limit=1] Rotation[0] set from entity @s Rotation[0]

execute as @e[type=marker,tag=fake_wall_place] at @s run setblock ~ ~ ~ barrier
execute as @e[type=marker,tag=fake_wall_place] at @s run setblock ~ ~1 ~ barrier



