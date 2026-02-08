#通常
execute if entity @s[team=Taoruboshi] run effect give @a[tag=5,limit=1] levitation 15 1 true
execute if entity @s[team=Taoruboshi] run tellraw @a [{"selector":"@a[tag=5,limit=1]","color":"aqua"},{"text":"は空に飛ばされた...","color":"green"}]
execute as entity @s[team=Taoruboshi] run effect give @s instant_health 1 255 true
execute if entity @s[team=Taoruboshi] as @s at @s run function werewolf:.system/player_attacked/taoruboshi_effect