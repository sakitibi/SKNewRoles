execute if entity @a[tag=8] run tellraw @s [{"selector":"@a[tag=8]"},{"text":"を凍結させた!\n彼はきっと凍りつくだろう。","color":"red"}]
execute as @s at @s run playsound minecraft:frozen master @s
execute as @a[tag=8] run schedule function werewolf:skill/skill_blacksnowgirl/.blacksnowgirl_main 15s append true