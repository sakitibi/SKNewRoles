execute as @a[team=Ryoushi] at @s if block ~ ~1 ~ minecraft:water run tag @s add ryoushi_water_inned
execute as @a[team=Ryoushi] at @s if block ~ ~1 ~ minecraft:flowing_water run tag @s add ryoushi_water_inned
execute as @a[team=Ryoushi] at @s if block ~ ~1 ~ minecraft:air run tag @s remove ryoushi_water_inned
effect give @a[tag=ryoushi_water_inned] water_breathing 1 255 true