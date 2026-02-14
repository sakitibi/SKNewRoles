execute if entity @a[tag=12] run tellraw @s [{"selector":"@a[tag=12]"},{"text":"を凍結させた!\n彼はきっと凍りつくだろう。","color":"red"}]
execute as @s at @s run playsound minecraft:frozen master @s
execute as @a[tag=12] run schedule function werewolf:skill/skill_blacksnowgirl/.blacksnowgirl_main 15s append true