execute as @e[tag=kakusei,scores={magic1=19}] at @s run item replace entity @s weapon.mainhand.0 with minecraft:grass 1 0
execute at @e[scores={magic1=19}] run damage @e[family=!monster,distance=..30] 50 magic by @e[scores={magic1=19},limit=1]
execute at @e[scores={magic1=19}] run effect give @e[family=!monster,distance=..30] slowness 5 2 true