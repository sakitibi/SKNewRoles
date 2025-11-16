function Adv_Map_Creator_data:animated_java/fake_wall/remove/all
execute as @e[type=marker,tag=fake_wall_place] at @s run setblock ~ ~ ~ air
execute as @e[type=marker,tag=fake_wall_place] at @s run setblock ~ ~1 ~ air
execute as @e[type=marker,tag=fake_wall_place] at @s run particle minecraft:cloud ~ ~0.5 ~ 0.5 0.5 0.5 0 3 force @a
execute as @e[type=marker,tag=fake_wall_place] at @s run particle minecraft:cloud ~ ~1.5 ~ 0.5 0.5 0.5 0 3 force @a
