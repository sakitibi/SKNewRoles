execute if entity @a[tag=7,tag=marking] run tellraw @s [{"selector":"@a[tag=7]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=7,tag=!marking] run tellraw @s [{"selector":"@a[tag=7]"},{"text":"をマーキングした。"}]
execute as @a[tag=7] run function werewolf:skill/skill_rimokon/add_marking