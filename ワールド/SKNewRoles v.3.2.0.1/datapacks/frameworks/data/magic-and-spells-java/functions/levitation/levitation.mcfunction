execute at @e[scores={witchtype=3}] run effect give @e[family=!monster,distance=..30] levitation 120 5 true
execute at @e[scores={witchtype=3}] run effect give @e[family=!monster,distance=..30] slowness 150 5 true
execute at @e[scores={witchtype=3}] run effect give @e[family=!monster,distance=..30] blindness 120 255 true
execute at @e[scores={witchtype=3}] run effect give @e[family=!monster,distance=..30] darkness 120 255 true
execute at @e[scores={witchtype=3}] run effect give @e[family=!monster,distance=..30] nausea 120 255 true
schedule function magic-and-spells-java:levitation/levitation_witch 30s append false