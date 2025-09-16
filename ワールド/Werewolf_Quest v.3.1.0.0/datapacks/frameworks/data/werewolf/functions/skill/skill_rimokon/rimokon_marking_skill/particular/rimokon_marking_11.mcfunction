execute if entity @a[tag=11,tag=marking] run tellraw @s [{"selector":"@a[tag=11]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=11,tag=!marking] run tellraw @s [{"selector":"@a[tag=11]"},{"text":"をマーキングした。"}]
execute as @a[tag=11] run function werewolf:skill/skill_rimokon/add_marking