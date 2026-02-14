#通常
execute if entity @s[team=Evilguesser] run damage @a[tag=2,limit=1] 0.01 fall by @s
execute if entity @s[team=Evilguesser] as @s at @s run function werewolf:.system/player_attacked/sword_effect