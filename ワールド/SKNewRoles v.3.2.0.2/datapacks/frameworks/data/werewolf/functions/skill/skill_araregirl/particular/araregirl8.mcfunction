execute if entity @a[tag=8] run tellraw @s [{"selector":"@a[tag=8]"},{"text":"を凍結させた"}]
execute as @a[tag=8] run schedule function werewolf:skill/skill_araregirl/.araregirl_main 15s append true