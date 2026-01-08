execute if entity @a[tag=2,tag=marking] run tellraw @s [{"selector":"@a[tag=2]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=2,tag=!marking] run tellraw @s [{"selector":"@a[tag=2]"},{"text":"をマーキングした。"}]
execute as @a[tag=2] run function werewolf:skill/skill_rimokon/add_marking