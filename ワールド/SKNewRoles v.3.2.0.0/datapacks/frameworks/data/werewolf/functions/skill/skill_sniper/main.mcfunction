#アイテムを飛ばす
execute anchored eyes run summon item ^ ^-0.25 ^ {Item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["roar","not_yet"],NoGravity:true,Age:5950}
damage @e[type=item,limit=1,sort=nearest,tag=roar,tag=not_yet] 0.0
execute rotated as @s positioned 0.0 0.0 0.0 run summon area_effect_cloud ^ ^ ^1.5 {Tags:["roar_motion"]}
execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] run data modify entity @s Motion set from entity @e[type=area_effect_cloud,tag=roar_motion,limit=1] Pos
kill @e[type=area_effect_cloud,tag=roar_motion,limit=1]

#壁や床に当たった時に消滅するための例外処理
execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] store result storage item: motion double 0.001 run data get entity @s Motion[0] 1000
execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] unless data storage item: {motion:0d} run tag @s add motion_x

execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] store result storage item: motion double 0.001 run data get entity @s Motion[1] 1000
execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] unless data storage item: {motion:0d} run tag @s add motion_y

execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] store result storage item: motion double 0.001 run data get entity @s Motion[2] 1000
execute as @e[type=item,tag=roar,tag=not_yet,limit=1,sort=nearest] unless data storage item: {motion:0d} run tag @s add motion_z

#処理終了
tag @e[type=item,tag=roar,tag=not_yet,sort=nearest,limit=1] remove not_yet

#演出等
playsound entity.warden.sonic_boom master @a ~ ~ ~ 1 1 0.5