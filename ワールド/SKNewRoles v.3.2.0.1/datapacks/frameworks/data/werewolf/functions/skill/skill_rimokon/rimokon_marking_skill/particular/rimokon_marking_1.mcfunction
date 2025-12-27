execute if entity @a[tag=1,tag=marking] run tellraw @s [{"selector":"@a[tag=1]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=1,tag=!marking] run tellraw @s [{"selector":"@a[tag=1]"},{"text":"をマーキングした。"}]
execute as @a[tag=1] run function werewolf:skill/skill_rimokon/add_marking