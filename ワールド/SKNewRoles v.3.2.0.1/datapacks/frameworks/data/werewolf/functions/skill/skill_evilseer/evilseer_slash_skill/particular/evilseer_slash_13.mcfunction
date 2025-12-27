#通常
execute if entity @s[team=Evilseer] run damage @a[tag=13,limit=1] 0.01 fall by @s
execute if entity @s[team=Evilseer] as @s at @s run function werewolf:.system/player_attacked/sword_effect