execute if entity @a[tag=6,tag=marking] run tellraw @s [{"selector":"@a[tag=6]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=6,tag=!marking] run tellraw @s [{"selector":"@a[tag=6]"},{"text":"をマーキングした。"}]
execute as @a[tag=6] run function werewolf:skill/skill_rimokon/add_marking