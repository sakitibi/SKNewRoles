execute if entity @a[tag=3,tag=marking] run tellraw @s [{"selector":"@a[tag=3]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=3,tag=!marking] run tellraw @s [{"selector":"@a[tag=3]"},{"text":"をマーキングした。"}]
execute as @a[tag=3] run function werewolf:skill/skill_rimokon/add_marking