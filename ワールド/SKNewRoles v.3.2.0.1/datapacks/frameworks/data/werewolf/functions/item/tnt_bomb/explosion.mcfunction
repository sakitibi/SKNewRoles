scoreboard players remove @s explosion_timer 1

execute if score @s explosion_timer matches 10 run playsound minecraft:entity.tnt.primed master @a

execute if score @s explosion_timer matches ..0 run particle minecraft:explosion ~0.5 ~ ~0.5 0.5 0.5 0.5 0 10 force @a
execute if score @s explosion_timer matches ..0 run particle minecraft:flame ~0.5 ~ ~0.5 0 0 0 0.2 10 force @a
execute if score @s explosion_timer matches ..0 run particle minecraft:smoke ~0.5 ~ ~0.5 0.5 0.5 0.5 0 20 force @a
execute if score @s explosion_timer matches ..0 run playsound minecraft:entity.generic.explode master @a
execute if score @s explosion_timer matches ..0 as @a[distance=..3] run damage @s 7 explosion
execute if score @s explosion_timer matches ..0 as @a[distance=3.00001..4] run damage @s 3 explosion
execute if score @s explosion_timer matches ..0 as @a[distance=4.00001..5] run damage @s 2 explosion



execute as @e[type=marker,limit=1,sort=nearest,tag=tnt_bomb_particle] run scoreboard players set @s explosion_timer 100

execute if score @s explosion_timer matches ..0 run kill @s