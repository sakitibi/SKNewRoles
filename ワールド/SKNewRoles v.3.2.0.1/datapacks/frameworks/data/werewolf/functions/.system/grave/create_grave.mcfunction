# クリック判定を召喚
execute as @s at @s run summon minecraft:interaction ~ ~ ~ {Tags:["grave","not_yet"],width:0.6f,height:0.6f}
# 墓石を召喚
execute as @s at @s run summon minecraft:item_display ~ ~0.5 ~ {item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:99}},Tags:["grave","grave_stone","not_yet"],transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],translation:[0,0,0],scale:[0.67f,0.67f,0.67f]}}
# 顔の土台を召喚
execute as @s at @s run summon minecraft:item_display ~ ~ ~ {Tags:["grave","grave_head","not_yet"],transformation:{left_rotation:[0,0,0,1],right_rotation:[0,0,0,1],translation:[0,0,0],scale:[0.33f,0.33f,0.33f]}}

# 顔を召喚
execute if entity @s[tag=grave_1] at @s as @a[tag=1] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_2] at @s as @a[tag=2] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_3] at @s as @a[tag=3] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_4] at @s as @a[tag=4] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_5] at @s as @a[tag=5] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_6] at @s as @a[tag=6] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_7] at @s as @a[tag=7] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_8] at @s as @a[tag=8] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_9] at @s as @a[tag=9] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_10] at @s as @a[tag=10] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_11] at @s as @a[tag=11] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_12] at @s as @a[tag=12] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head
execute if entity @s[tag=grave_13] at @s as @a[tag=13] run loot replace entity @e[sort=nearest,limit=1,tag=grave,tag=grave_head,tag=not_yet] container.0 loot werewolf:player_head

# 向きと高さを合わせる
execute as @s at @s run tp @e[tag=grave,tag=not_yet,tag=grave_stone,limit=1] ~ ~0.329 ~ ~-180 0
execute as @s at @s run tp @e[tag=grave,tag=not_yet,tag=grave_head,limit=1] ~ ~0.245 ~ ~ 0

# 死者判別用のタグを付加
execute if entity @s[tag=grave_1] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 1
execute if entity @s[tag=grave_2] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 2
execute if entity @s[tag=grave_3] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 3
execute if entity @s[tag=grave_4] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 4
execute if entity @s[tag=grave_5] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 5
execute if entity @s[tag=grave_6] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 6
execute if entity @s[tag=grave_7] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 7
execute if entity @s[tag=grave_8] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 8
execute if entity @s[tag=grave_9] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 9
execute if entity @s[tag=grave_10] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 10
execute if entity @s[tag=grave_11] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 11
execute if entity @s[tag=grave_12] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 12
execute if entity @s[tag=grave_13] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] add 13

# 識別タグを削除
execute if entity @e[type=item_display,tag=not_yet,tag=grave_head,sort=nearest,limit=1] run tag @e[type=item_display,tag=not_yet,sort=nearest,limit=1] remove not_yet
execute if entity @e[type=item_display,tag=not_yet,tag=grave_stone,sort=nearest,limit=1] run tag @e[type=item_display,tag=not_yet,sort=nearest,limit=1] remove not_yet
execute if entity @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] run tag @e[type=interaction,tag=grave,tag=not_yet,sort=nearest,limit=1] remove not_yet

# 自らを削除
kill @s