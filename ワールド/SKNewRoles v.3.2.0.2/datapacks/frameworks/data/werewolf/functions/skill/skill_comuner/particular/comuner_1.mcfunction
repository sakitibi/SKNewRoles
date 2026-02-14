#通常
execute if entity @s[team=Comuner] run damage @a[tag=1,limit=1] 0.01 fall by @s
scoreboard players add @s[team=Comuner] comuner_fined 1
execute if entity @s[team=Comuner] as @s at @s run function werewolf:.system/player_attacked/sword_effect