scoreboard players remove @s explosion_timer 1

execute if score @s explosion_timer matches 5 run particle minecraft:campfire_cosy_smoke ~0.5 ~ ~0.5 0.5 0.5 0.5 0 50 force @a
execute if score @s explosion_timer matches 5 run particle minecraft:smoke ~0.5 ~ ~0.5 0.5 0.5 0.5 0 20 force @a
execute if score @s explosion_timer matches 5 run playsound minecraft:block.wool.place master @a
execute if score @s explosion_timer matches 5 run effect give @a[distance=..1] slowness 1 5 true
execute if score @s explosion_timer matches 5 run effect give @a[distance=..1] blindness 3 0 true
execute if score @s explosion_timer matches 3 run particle minecraft:campfire_cosy_smoke ~0.5 ~ ~0.5 2 2 2 0 70 force @a
execute if score @s explosion_timer matches 3 run particle minecraft:smoke ~0.5 ~ ~0.5 2 2 2 0 20 force @a
execute if score @s explosion_timer matches 3 run playsound minecraft:block.wool.place master @a
execute if score @s explosion_timer matches 3 run effect give @a[distance=..3] slowness 1 5 true
execute if score @s explosion_timer matches 3 run effect give @a[distance=..3] blindness 3 0 true
execute if score @s explosion_timer matches ..0 run particle minecraft:campfire_cosy_smoke ~0.5 ~ ~0.5 2.5 2.5 2.5 0 150 force @a
execute if score @s explosion_timer matches ..0 run particle minecraft:smoke ~0.5 ~ ~0.5 2.5 2.5 2.5 0 20 force @a
execute if score @s explosion_timer matches ..0 run playsound minecraft:block.wool.place master @a
execute if score @s explosion_timer matches ..0 run effect give @a[distance=..7] slowness 1 5 true
execute if score @s explosion_timer matches ..0 run effect give @a[distance=..7] blindness 3 0 true
execute as @e[type=marker,limit=1,sort=nearest,tag=smoke_bomb_particle] run scoreboard players set @s explosion_timer 100

execute if score @s explosion_timer matches ..0 run kill @s