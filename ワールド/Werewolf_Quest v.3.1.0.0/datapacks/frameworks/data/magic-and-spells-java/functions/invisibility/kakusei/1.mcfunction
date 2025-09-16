execute as @e[tag=kakusei,scores={magic1=1}] at @s run item replace entity @s weapon.mainhand.0 with minecraft:echo_shard
execute at @e[tag=kakusei,scores={magic1=1}] run effect give @a[distance=..30] darkness 40 255 true
execute at @e[tag=kakusei,scores={magic1=1}] run effect give @a[distance=..30] blindness 40 255 true
execute at @e[tag=kakusei,scores={magic1=1}] run effect give @a[distance=..30] nausea 40 255 true
effect give @e[type=witch,tag=kakusei,scores={magic1=1}] invisibility 60 255 true