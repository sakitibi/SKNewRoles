execute if entity @a[tag=9,tag=marking] run tellraw @s [{"selector":"@a[tag=9]"},{"text":"はすでにマーキングしてたようだ。"}]
execute if entity @a[tag=9,tag=!marking] run tellraw @s [{"selector":"@a[tag=9]"},{"text":"をマーキングした。"}]
execute as @a[tag=9] run function werewolf:skill/skill_rimokon/add_markingword_effect