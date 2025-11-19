# オークの木材
execute align xyz if entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"既にマーカーが設置されています。"}
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute align xyz unless entity @e[type=marker,tag=task_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["task_point","size_normal","oak_log"]}
#可視化のためにPlayerHeadを設置
execute align xyz run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;1207148445,-290502372,-1986008042,-746691525],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2YxMzQ2MDkyYzgwZDNkYjIxN2VmZTRjOTM2OTY5MWU2MWM4YWZjMWIyODc0MWZhNTA0ODJjOTJjOWZkM2QxOCJ9fX0="}]}}} replace