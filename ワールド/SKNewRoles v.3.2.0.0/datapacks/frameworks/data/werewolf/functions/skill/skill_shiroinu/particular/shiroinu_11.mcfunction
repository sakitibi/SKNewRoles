execute if entity @s[team=Shiroinu] run damage @a[tag=11,limit=1] 10 fall by @s
execute if entity @s[team=Shiroinu] run effect give @a[tag=11,limit=1] wither 16 0
execute if entity @s[team=Shiroinu] as @s at @s run function werewolf:.system/player_attacked/sword_effect