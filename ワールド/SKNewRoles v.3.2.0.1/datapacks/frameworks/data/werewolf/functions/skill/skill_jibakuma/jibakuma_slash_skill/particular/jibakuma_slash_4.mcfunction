#通常
execute if entity @s[team=Jibakuma] run damage @a[tag=4,limit=1] 0.01 fall by @s
execute if entity @s[team=Jibakuma] as @s at @s run function werewolf:.system/player_attacked/sword_effect