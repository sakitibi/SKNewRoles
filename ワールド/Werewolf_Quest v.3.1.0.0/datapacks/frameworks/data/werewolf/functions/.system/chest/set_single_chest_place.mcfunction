
execute align xyz if entity @e[type=marker,tag=chest_point,distance=..0.5] run tellraw @p {"text":"既にマーカーが設置されています。"}
execute align xyz unless entity @e[type=marker,tag=chest_point,distance=..0.5] run tellraw @p {"text":"マーカーを設置しました。"}

#s
#Makerを設置
execute if entity @s[y_rotation=-45..44.9] align xyz unless entity @e[type=marker,tag=chest_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_single","south"]}
execute align xyz if entity @e[type=marker,tag=chest_point,tag=south,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=8]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace

#w
execute if entity @s[y_rotation=45..134.9] align xyz unless entity @e[type=marker,tag=chest_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_single","west"]}
execute align xyz if entity @e[type=marker,tag=chest_point,tag=west,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=12]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace

#n
execute if entity @s[y_rotation=135..224.9] align xyz unless entity @e[type=marker,tag=chest_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_single","north"]}
execute align xyz if entity @e[type=marker,tag=chest_point,tag=north,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace

#e
execute if entity @s[y_rotation=225..314.9] align xyz unless entity @e[type=marker,tag=chest_point,distance=..0.5] run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_single","east"]}
execute align xyz if entity @e[type=marker,tag=chest_point,tag=east,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=4]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace













