#通常
execute if entity @s[team=Jinrou] run damage @a[tag=13,limit=1] 0.01 fall by @s
execute if entity @s[team=Jinrou] as @s at @s run function werewolf:.system/player_attacked/sword_effect
#ポンコツ
execute if entity @s[team=Ponkotsu] run damage @a[tag=13,limit=1] 1 fall
execute if entity @s[team=Ponkotsu] as @s at @s run function werewolf:.system/player_attacked/sword_effect_dummy
#アサシン
execute if entity @s[team=Asasine] run damage @a[tag=13,limit=1] 0.01 fall by @s
execute if entity @s[team=Asasine] as @s at @s run function werewolf:.system/player_attacked/sword_effect