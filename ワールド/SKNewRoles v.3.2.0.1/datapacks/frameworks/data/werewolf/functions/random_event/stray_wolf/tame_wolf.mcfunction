execute as @s[tag=1] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run particle minecraft:heart ~ ~0.3 ~ 0.3 0.3 0.3 0 5 force @a
#1
execute as @s[tag=1] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=1] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=1] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 1_wolf
execute as @s[tag=1] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=1] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#2
execute as @s[tag=2] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=2] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=2] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 2_wolf
execute as @s[tag=2] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=2] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#3
execute as @s[tag=3] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=3] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=3] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 3_wolf
execute as @s[tag=3] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=3] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#4
execute as @s[tag=4] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=4] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=4] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 4_wolf
execute as @s[tag=4] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=4] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#5
execute as @s[tag=5] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=5] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=5] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 5_wolf
execute as @s[tag=5] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=5] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#6
execute as @s[tag=6] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=6] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=6] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 6_wolf
execute as @s[tag=6] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=6] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#7
execute as @s[tag=7] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=7] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=7] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 7_wolf
execute as @s[tag=7] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=7] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#8
execute as @s[tag=8] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=8] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=8] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 8_wolf
execute as @s[tag=8] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=8] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#9
execute as @s[tag=9] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=9] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=9] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 9_wolf
execute as @s[tag=9] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=9] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#10
execute as @s[tag=10] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=10] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=10] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 10_wolf
execute as @s[tag=10] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=10] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#11
execute as @s[tag=11] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=11] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=11] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 11_wolf
execute as @s[tag=11] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=11] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#12
execute as @s[tag=12] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=12] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=12] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 12_wolf
execute as @s[tag=12] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=12] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]
#13
execute as @s[tag=13] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Owner set from entity @s UUID
execute as @s[tag=13] at @e[type=interaction,tag=event_wolf,distance=..3] run data modify entity @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] Sitting set value true
execute as @s[tag=13] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] add 12_wolf
execute as @s[tag=13] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run tag @e[type=wolf,tag=event_wolf,limit=1,distance=..0.5] remove no_tame
execute as @s[tag=13] at @e[type=interaction,tag=event_wolf,distance=..3,nbt=!{interaction:""}] run kill @e[type=interaction,tag=event_wolf,distance=..0.5]

#狼をテイムした人の基礎速度を上げる
attribute @s[tag=no_jinrou] minecraft:generic.movement_speed base set 0.11
attribute @s[tag=!no_jinrou,team=!Witch] minecraft:generic.movement_speed base set 0.15
execute if data storage sys: {witch_weakness:true} run attribute @s[tag=!no_jinrou,team=Witch,tag=!Sorceress] minecraft:generic.movement_speed base set 0.15
execute if data storage sys: {witch_weakness:true} run attribute @s[tag=!no_jinrou,team=Witch,tag=Sorceress] minecraft:generic.movement_speed base set 0.20
execute if data storage sys: {witch_weakness:false} run attribute @s[tag=!no_jinrou,team=Witch] minecraft:generic.movement_speed base set 0.20

title @a title {"interpret":true,"nbt":"quest_success","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"stray_wolf.announce.success.1","storage":"wolf_data:"}

advancement revoke @s only werewolf:random_event/event_5/tame_wolf