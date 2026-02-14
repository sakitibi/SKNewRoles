execute if entity @a[tag=10,tag=marking] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=10,tag=!marking] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"をマーキングした。"}]
execute as @a[tag=10] run function werewolf:skill/skill_rimokon/add_marking