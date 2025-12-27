execute if entity @a[tag=8,tag=marking] run tellraw @s [{"selector":"@a[tag=8]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=8,tag=!marking] run tellraw @s [{"selector":"@a[tag=8]"},{"text":"をマーキングした。"}]
execute as @a[tag=8] run function werewolf:skill/skill_rimokon/add_marking