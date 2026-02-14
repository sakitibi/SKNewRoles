execute if entity @a[tag=13,tag=marking] run tellraw @s [{"selector":"@a[tag=13]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=13,tag=!marking] run tellraw @s [{"selector":"@a[tag=13]"},{"text":"をマーキングした。"}]
execute as @a[tag=13] run function werewolf:skill/skill_rimokon/add_marking