#通常
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=camp_red,team=!Witch] run kill @a[tag=10,tag=camp_red,team=!Witch]
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=camp_pink,team=!Witch] run kill @a[tag=10,tag=camp_pink]
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=camp_red,team=!Witch] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"は人外だったようだ。"}]
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=camp_pink] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"は人外だったようだ。"}]
execute if entity @s[team=Hoankan] as @s at @s run function werewolf:.system/player_attacked/sword_effect
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=!camp_red,tag=!camp_pink] run kill @s
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=camp_red,team=Witch] run kill @s
execute if entity @s[team=Hoankan] if entity @a[tag=10,tag=camp_red,team=Witch] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"は魔女だったようだ。"}]

#ポンコツ用
execute if entity @s[team=Ponkotsu] run damage @a[tag=10,limit=1] 1 fall
execute if entity @s[team=Ponkotsu] run tellraw @s [{"selector":"@a[tag=10]"},{"text":"は人外だったようだ。"}]
execute if entity @s[team=Ponkotsu] as @s at @s run function werewolf:.system/player_attacked/sword_effect_dummy