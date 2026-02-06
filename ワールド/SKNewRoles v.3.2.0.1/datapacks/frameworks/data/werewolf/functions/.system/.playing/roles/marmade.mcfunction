# 元々の役職効果が薄いのでエフェクトを強化
execute as @a[team=Marmade] at @s if block ~ ~1 ~ minecraft:water run tag @s add marmade_water_inned
execute as @a[team=Marmade] at @s if block ~ ~1 ~ minecraft:flowing_water run tag @s add marmade_water_inned
execute as @a[team=Marmade] at @s if block ~ ~1 ~ minecraft:air run tag @s remove marmade_water_inned
effect give @a[tag=marmade_water_inned] water_breathing 1 255 true
effect give @a[tag=marmade_water_inned] haste 1 1 true
effect give @a[tag=marmade_water_inned] strength 1 2 true
execute as entity @a[tag=!SuperMarmade] run effect give @s[tag=marmade_water_inned] speed 1 2 true
execute as entity @a[tag=SuperMarmade] run effect give @s[tag=marmade_water_inned] speed 1 4 true
execute as entity @a[tag=!SuperMarmade] run effect give @s[tag=marmade_water_inned] regeneration 1 0 true
execute as entity @a[tag=SuperMarmade] run effect give @s[tag=marmade_water_inned] regeneration 1 2 true
execute as entity @a[tag=!SuperMarmade] run effect give @s[tag=marmade_water_inned] resistance 1 0 true
execute as entity @a[tag=SuperMarmade] run effect give @s[tag=marmade_water_inned] resistance 1 1 true