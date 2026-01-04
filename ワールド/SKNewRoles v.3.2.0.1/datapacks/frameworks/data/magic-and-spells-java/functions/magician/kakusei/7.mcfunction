execute as @e[tag=kakusei,scores={magic1=7}] run item replace entity @s weapon.mainhand.0 with minecraft:enchanted_book 1
execute at @e[tag=kakusei,scores={magic1=7}] run effect give @e[family=!monster,distance=..30] slowness 40 2 true
execute at @e[tag=kakusei,scores={magic1=7}] run effect give @e[family=!monster,distance=..30] levitation 50 4 true