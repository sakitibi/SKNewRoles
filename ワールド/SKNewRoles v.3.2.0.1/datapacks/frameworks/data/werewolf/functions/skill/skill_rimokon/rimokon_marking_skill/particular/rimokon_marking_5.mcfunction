execute if entity @a[tag=5,tag=marking] run tellraw @s [{"selector":"@a[tag=5]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=5,tag=!marking] run tellraw @s [{"selector":"@a[tag=5]"},{"text":"をマーキングした。"}]
execute as @a[tag=5] run function werewolf:skill/skill_rimokon/add_marking