execute if entity @a[tag=2] run tellraw @s [{"selector":"@a[tag=2]"},{"text":"を凍結させた"}]
execute as @a[tag=2] run schedule function werewolf:skill/skill_araregirl/.araregirl_main 15s append true