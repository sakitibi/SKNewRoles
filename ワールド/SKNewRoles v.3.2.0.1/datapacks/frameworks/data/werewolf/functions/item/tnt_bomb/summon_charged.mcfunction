summon item ~ ~ ~ {Item:{id:"minecraft:snowball",Count:1b,tag:{CustomModelData:2}},Health:1s,PickupDelay:10000,Tags:["tnt_bomb","not_yet"]}
data modify entity @e[type=item,tag=tnt_bomb,sort=nearest,limit=1] Motion set from entity @s Motion
damage @e[type=item,limit=1,sort=nearest,tag=tnt_bomb,tag=not_yet] 0.0
execute as @e[type=item,limit=1,sort=nearest,tag=tnt_bomb,tag=not_yet] run scoreboard players set @s explosion_timer 45
tag @e[type=item,limit=1,sort=nearest,tag=tnt_bomb,tag=not_yet] remove not_yet
kill @s