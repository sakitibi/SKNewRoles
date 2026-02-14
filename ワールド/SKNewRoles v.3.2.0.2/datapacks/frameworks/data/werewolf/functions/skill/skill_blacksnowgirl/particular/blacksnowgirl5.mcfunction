execute if entity @a[tag=5] run tellraw @s [{"selector":"@a[tag=5]"},{"text":"を凍結させた!\n彼はきっと凍りつくだろう。","color":"red"}]
execute as @s at @s run playsound minecraft:frozen master @s
execute as @a[tag=5] run schedule function werewolf:skill/skill_blacksnowgirl/.blacksnowgirl_main 15s append true