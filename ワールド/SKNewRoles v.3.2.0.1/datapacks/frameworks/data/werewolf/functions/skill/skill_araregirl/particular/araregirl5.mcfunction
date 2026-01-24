execute if entity @a[tag=5] run tellraw @s [{"selector":"@a[tag=5]"},{"text":"を凍結させた"}]
execute as @a[tag=5] run schedule function werewolf:skill/skill_araregirl/.araregirl_main 15s append true