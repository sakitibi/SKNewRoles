execute as @e[tag=!kakusei,scores={magic1=5}] run item replace entity @s weapon.mainhand.0 with minecraft:enchanted_book
execute at @e[tag=!kakusei,scores={magic1=5}] run effect give @e[family=!monster,distance=..20] wither 30 1 true
execute at @e[tag=!kakusei,scores={magic1=5}] run effect give @e[family=!monster,distance=..20] weakness 30 3 true