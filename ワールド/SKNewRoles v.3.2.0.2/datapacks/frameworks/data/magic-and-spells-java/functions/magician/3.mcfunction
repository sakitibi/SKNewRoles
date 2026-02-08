execute as @e[scores={magic1=3}] run item replace entity @s weapon.mainhand.0 with minecraft:clock
execute at @e[scores={magic1=3}] run effect give @e[type=!witch,type=!bat,distance=..20] slowness 20 255 true
execute at @e[scores={magic1=3}] run effect give @e[type=!witch,type=!bat,distance=..20] slow_falling 20 255 true
execute at @e[scores={magic1=3}] run effect give @e[type=!witch,type=!bat,distance=..20] mining_fatigue 20 255 true
execute as @e[tag=!kakusei,scores={magic1=3}] run time set midnight