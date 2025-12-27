# 元々の役職効果が薄いのでエフェクトを強化
execute as @a[team=Marmade] at @s if block ~ ~1 ~ minecraft:water run tag @s add marmade_water_inned
execute as @a[team=Marmade] at @s if block ~ ~1 ~ minecraft:flowing_water run tag @s add marmade_water_inned
execute as @a[team=Marmade] at @s if block ~ ~1 ~ minecraft:air run tag @s remove marmade_water_inned
effect give @a[tag=marmade_water_inned] conduit_power 1 0 true
effect give @a[tag=marmade_water_inned] strength 1 2 true