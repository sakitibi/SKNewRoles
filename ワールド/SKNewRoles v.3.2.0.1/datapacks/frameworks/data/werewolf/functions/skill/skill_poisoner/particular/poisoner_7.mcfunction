#通常
execute if entity @s[team=Poisoner] run scoreboard players set @a[tag=7,limit=1] poisoner_timelimit 10
execute if entity @s[team=Poisoner] as @s at @s run function werewolf:.system/player_attacked/sword_effect