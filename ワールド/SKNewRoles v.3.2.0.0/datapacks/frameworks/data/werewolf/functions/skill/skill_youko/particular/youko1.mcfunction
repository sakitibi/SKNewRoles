execute if entity @a[tag=1,team=Haitoku] run tellraw @s [{"selector":"@a[tag=1]"},{"text":"はすでに背徳者のようだ。"}]
execute if entity @a[tag=1,team=!Haitoku] run tellraw @s [{"selector":"@a[tag=1]"},{"text":"を背徳者として従えた。"}]
execute as @a[tag=1,team=!Haitoku] run tellraw @s [{"text":"あなたは背徳者になった。"}]

execute as @a[tag=1] run function werewolf:skill/skill_youko/change_role
execute as @a[tag=1] at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s
execute as @s at @s run particle soul_fire_flame ~ ~1 ~ 0.5 0.5 0.5 0 10 force @s
execute as @a[tag=1] at @s run playsound minecraft:entity.blaze.shoot master @s
execute as @s at @s run playsound minecraft:entity.blaze.shoot master @s