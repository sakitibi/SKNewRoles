# 小麦
execute align xyz if entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"既にマーカーが設置されています。"}
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["task_point","size_normal","wheat"]}
#可視化のためにPlayerHeadを設置
execute align xyz run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;-1656711687,542984256,-1721527000,-1786945376],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg2YmFkYjBkOTEzYjM5MWZiNDhkNzc3NmMzNzhjYTNmNGIyZGJlNzI0NTM0MDM0ZjM1MGNjZDM4ZjkwNDQ3MyJ9fX0="}]}}} replace