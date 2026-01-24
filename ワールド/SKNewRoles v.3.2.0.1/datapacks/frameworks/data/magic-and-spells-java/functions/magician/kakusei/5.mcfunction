execute as @e[tag=kakusei,scores={magic1=5}] run item replace entity @s weapon.mainhand.0 with minecraft:enchanted_book
execute at @e[tag=kakusei,scores={magic1=5}] run effect give @e[family=!monster,distance=..30] wither 40 2 true
execute at @e[tag=kakusei,scores={magic1=5}] run effect give @e[family=!monster,distance=..30] weakness 40 4 true
execute at @e[tag=kakusei,scores={magic1=5}] run effect give @e[family=!monster,distance=..30] instant_damage 1 2 true