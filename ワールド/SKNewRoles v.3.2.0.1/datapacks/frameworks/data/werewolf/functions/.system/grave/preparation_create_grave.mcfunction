#墓の準備
execute as @s[tag=1] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_1","not_yet"]}
execute as @s[tag=2] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_2","not_yet"]}
execute as @s[tag=3] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_3","not_yet"]}
execute as @s[tag=4] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_4","not_yet"]}
execute as @s[tag=5] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_5","not_yet"]}
execute as @s[tag=6] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_6","not_yet"]}
execute as @s[tag=7] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_7","not_yet"]}
execute as @s[tag=8] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_8","not_yet"]}
execute as @s[tag=9] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_9","not_yet"]}
execute as @s[tag=10] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_10","not_yet"]}
execute as @s[tag=11] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_11","not_yet"]}
execute as @s[tag=12] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_12","not_yet"]}
execute as @s[tag=13] run summon minecraft:item ~ ~1 ~ {Item:{id:"minecraft:netherite_block",Count:1b,tag:{CustomModelData:99999}},Health:1s,PickupDelay:10000,Tags:["grave","grave_13","not_yet"]}

#プレイヤーの向きを代入
execute as @s at @s run data modify entity @e[type=item,sort=nearest,limit=1,tag=grave,tag=not_yet] Rotation set from entity @s Rotation