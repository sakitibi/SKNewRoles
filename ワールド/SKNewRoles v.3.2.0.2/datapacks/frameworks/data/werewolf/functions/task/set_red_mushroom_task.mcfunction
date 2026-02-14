# 小麦
execute align xyz if entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"既にマーカーが設置されています。"}
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["task_point","size_small","red_mushroom"]}
#可視化のためにPlayerHeadを設置
execute align xyz run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;-1976007106,-622836564,-1966190128,-248744622],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDQzMjIzYjZjMjllZjY1MmMzNjM2YWY3NzZkODk0NjZlOWY2OTdmMjU2NWI5Njc0YWE4ZGUwZTljMzZkNyJ9fX0="}]}}} replace