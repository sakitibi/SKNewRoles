execute if entity @a[tag=7] run tellraw @s [{"selector":"@a[tag=7]"},{"text":"を凍結させた"}]
execute as @a[tag=7] run schedule function werewolf:skill/skill_araregirl/.araregirl_main 15s append true