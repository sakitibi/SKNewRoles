execute if entity @a[tag=12] run tellraw @s [{"selector":"@a[tag=12]"},{"text":"を凍結させた"}]
execute as @a[tag=12] run schedule function werewolf:skill/skill_araregirl/.araregirl_main 15s append true