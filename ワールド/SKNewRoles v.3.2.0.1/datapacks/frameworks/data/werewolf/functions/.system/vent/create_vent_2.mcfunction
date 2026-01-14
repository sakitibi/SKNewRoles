execute align xyz run summon interaction ~ ~ ~ {Tags:["vent","vent_2","not_yet"],height:0.1f}
execute align xyz run tp @e[type=minecraft:interaction,tag=vent_2,tag=not_yet,limit=1,sort=nearest] ~0.5 ~ ~0.5 ~ ~
execute align xyz run summon minecraft:item_display ~0.5 ~0.5 ~0.5 {item:{id:"blue_carpet",Count:1b},Tags:["vent","vent_2"]}
execute if entity @e[type=interaction,tag=vent_2,tag=not_yet,sort=nearest,limit=1] run tag @e[type=interaction,tag=vent_2,tag=not_yet,sort=nearest,limit=1] remove not_yet