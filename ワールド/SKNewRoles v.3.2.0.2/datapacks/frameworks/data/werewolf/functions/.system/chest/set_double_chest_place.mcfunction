#ラージチェストは右側に伸ばす

#s
#アナウンス
execute if entity @s[y_rotation=-45..44.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ unless entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=-45..44.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ if entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=-45..44.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ if entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=-45..44.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ unless entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute if entity @s[y_rotation=-45..44.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ unless entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_left_double","south"]}
execute if entity @s[y_rotation=-45..44.9] align xyz if entity @e[type=marker,tag=chest_point,tag=type_left_double,distance=..0.5] run summon minecraft:marker ~-1 ~ ~ {Tags:["chest_point","type_right_double","south"]}
#Player_Headを設置
execute align xyz if entity @e[type=marker,tag=chest_point,tag=south,tag=type_left_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=8]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace
execute align xyz positioned ~-1 ~ ~ if entity @e[type=marker,tag=chest_point,tag=south,tag=type_right_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=8]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace


#w
#アナウンス
execute if entity @s[y_rotation=45..134.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=45..134.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=45..134.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=45..134.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute if entity @s[y_rotation=45..134.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_left_double","west"]}
execute if entity @s[y_rotation=45..134.9] align xyz if entity @e[type=marker,tag=chest_point,tag=type_left_double,distance=..0.5] run summon minecraft:marker ~ ~ ~-1 {Tags:["chest_point","type_right_double","west"]}
#Player_Headを設置
execute align xyz if entity @e[type=marker,tag=chest_point,tag=west,tag=type_left_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=12]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace
execute align xyz positioned ~ ~ ~-1 if entity @e[type=marker,tag=chest_point,tag=west,tag=type_right_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=12]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace


#n
#アナウンス
execute if entity @s[y_rotation=135..224.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ unless entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=135..224.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ if entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=135..224.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ if entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=135..224.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ unless entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute if entity @s[y_rotation=135..224.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~1 ~ ~ unless entity @e[type=marker,distance=..0.5] positioned ~-1 ~ ~ run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_left_double","north"]}
execute if entity @s[y_rotation=135..224.9] align xyz if entity @e[type=marker,tag=chest_point,tag=type_left_double,distance=..0.5] run summon minecraft:marker ~1 ~ ~ {Tags:["chest_point","type_right_double","north"]}
#Player_Headを設置
execute align xyz if entity @e[type=marker,tag=chest_point,tag=north,tag=type_left_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace
execute align xyz positioned ~1 ~ ~ if entity @e[type=marker,tag=chest_point,tag=north,tag=type_right_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=0]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace


#e
#アナウンス
execute if entity @s[y_rotation=225..314.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=225..314.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=225..314.9] align xyz if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 if entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 run tellraw @p {"text":"既にマーカーが設置されています。"}
execute if entity @s[y_rotation=225..314.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 run tellraw @p {"text":"マーカーを設置しました。"}
#Makerを設置
execute if entity @s[y_rotation=225..314.9] align xyz unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~1 unless entity @e[type=marker,distance=..0.5] positioned ~ ~ ~-1 run summon minecraft:marker ~ ~ ~ {Tags:["chest_point","type_left_double","east"]}
execute if entity @s[y_rotation=225..314.9] align xyz if entity @e[type=marker,tag=chest_point,tag=type_left_double,distance=..0.5] run summon minecraft:marker ~ ~ ~1 {Tags:["chest_point","type_right_double","east"]}
#Player_Headを設置
execute align xyz if entity @e[type=marker,tag=chest_point,tag=east,tag=type_left_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=4]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace
execute align xyz positioned ~ ~ ~1 if entity @e[type=marker,tag=chest_point,tag=east,tag=type_right_double,distance=..0.5] run setblock ~ ~ ~ minecraft:player_head[rotation=4]{SkullOwner:{Id:[I;1431137794,275073127,-2022788867,-1955600531],Properties:{textures:[{Value:"eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWRjMzZjOWNiNTBhNTI3YWE1NTYwN2EwZGY3MTg1YWQyMGFhYmFhOTAzZThkOWFiZmM3ODI2MDcwNTU0MGRlZiJ9fX0="}]}}} replace













