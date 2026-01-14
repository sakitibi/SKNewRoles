execute if entity @a[tag=10,team=Sidekick] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"はすでにサイドキックのようだ。"}]
execute if entity @a[tag=10,team=!Sidekick] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"をサイドキックとして従えた。"}]
execute as @a[tag=10,team=!Sidekick] run tellraw @s [{"text":"あなたはサイドキックになった。"}]

execute as @a[tag=10] run function werewolf:skill/skill_jackal/change_role
execute as @a[tag=10] at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s
execute as @s at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s
execute as @a[tag=10] at @s run playsound minecraft:entity.blaze.shoot master @s
execute as @s at @s run playsound minecraft:entity.blaze.shoot master @s