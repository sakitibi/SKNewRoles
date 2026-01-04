# 茶色のキノコ
execute align xyz if entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"既にマーカーが設置されています。"}
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["task_point","size_small","brown_mushroom"]}
#可視化のためにPlayerHeadを設置
execute align xyz run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;1121509275,1330332734,-1576779154,707436345],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYzZlMTJjZmYxMzhmZDJmZGMzMWM2OTU1NmNjYWFlYzdhZWQxNmY1ZDMxOGQ3YmMwOGU1MTRhZDY2MTg2MWJiMSJ9fX0="}]}}} replace