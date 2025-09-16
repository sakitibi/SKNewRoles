#通常
execute if entity @s[team=Rimokon] run damage @a[tag=5,limit=1] 0.01 fall by @s
execute if entity @s[team=Rimokon] as @s at @s run function werewolf:.system/player_attacked/sword_effect