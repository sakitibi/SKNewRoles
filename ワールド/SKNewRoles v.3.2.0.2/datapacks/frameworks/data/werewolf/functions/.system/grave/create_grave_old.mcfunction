# 墓石を設置
summon minecraft:item_frame ~ ~ ~ {Tags:["grave","grave_head","not_yet"],Facing:1,Invulnerable:1,Invisible:1,Item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:99}},ItemRotation:4,Fixed:1}
# プレイヤーの頭設置用の額縁を設置
summon minecraft:item_frame ~ ~ ~ {Tags:["grave","grave_stone","not_yet"],Facing:1,Invulnerable:1,Invisible:1,Item:{id:"minecraft:player_head",Count:1b},Fixed:1}
# プレイヤーの頭を設置
loot replace entity @e[type=item_frame,sort=nearest,limit=1,tag=grave_stone,tag=not_yet] container.0 loot werewolf:player_head
# クリック検知用のオブジェクトを設置
execute align xyz run summon minecraft:interaction ~0.5 ~ ~0.5 {Tags:["grave","not_yet"],width:0.55,height:0.55}
# 向きを変更
execute align xyz run tp @e[type=interaction,sort=nearest,limit=1,tag=grave,tag=not_yet] @s
execute align xyz run tp @e[type=interaction,sort=nearest,limit=1,tag=grave,tag=not_yet] ~0.5 ~ ~0.5

#墓の向き変更
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=-22.5..22.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:8}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=-22.5..22.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:4}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=22.5..67.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:1}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=22.5..67.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:5}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=67.5..112.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:2}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=67.5..112.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:6}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=112.5..157.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:3}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=112.5..157.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:7}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=157.5..202.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:4}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=157.5..202.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:8}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=202.5..247.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:5}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=202.5..247.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:1}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=247.4..292.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:6}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=247.4..292.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:2}

execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=292.5..337.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_head,sort=nearest] {ItemRotation:7}
execute if entity @e[type=interaction,tag=grave,tag=not_yet,y_rotation=292.5..337.4,sort=nearest,limit=1] run data merge entity @e[limit=1,type=item_frame,tag=grave,tag=not_yet,tag=grave_stone,sort=nearest] {ItemRotation:3}


# 死者判別用のタグを付加
execute if entity @s[tag=1] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 1
execute if entity @s[tag=2] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 2
execute if entity @s[tag=3] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 3
execute if entity @s[tag=4] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 4
execute if entity @s[tag=5] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 5
execute if entity @s[tag=6] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 6
execute if entity @s[tag=7] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 7
execute if entity @s[tag=8] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 8
execute if entity @s[tag=9] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 9
execute if entity @s[tag=10] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 10
execute if entity @s[tag=11] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 11
execute if entity @s[tag=12] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 12
execute if entity @s[tag=13] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 13

# 識別タグを削除
execute if entity @e[type=item_frame,tag=not_yet,tag=grave_head,sort=nearest,limit=1] run tag @e[type=item_frame,tag=not_yet,sort=nearest,limit=1] remove not_yet
execute if entity @e[type=item_frame,tag=not_yet,tag=grave_stone,sort=nearest,limit=1] run tag @e[type=item_frame,tag=not_yet,sort=nearest,limit=1] remove not_yet
execute if entity @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] remove not_yet









#execute at Utai_ch run summon minecraft:item_display ~ ~ ~ {Tags:["test"],transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],translation:[0,0,0],scale:[0.37f,0.37f,0.37f]}}

#/execute as Utai_ch at @s run tp @e[tag=test,limit=1] ~ ~0.329 ~ ~-180 0
#/summon minecraft:interaction ~ ~ ~ {Tags:["test3"],width:0.55f,height:0.55f}