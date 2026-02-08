# 魔女に魔法をかけられた人からパーティクルを魔女に向けて出す
    execute as @a[team=Witch] at @s run execute as @a[tag=warlock_curse] at @s run particle minecraft:dust{color:[0.5,0.0,0.7],scale:1} ~ ~1 ~ 0 0 0 0.1 100
# 魔女弱体化
    execute if data storage sys: {witch_weakness:true} run effect give @a[team=Witch,tag=!Sorceress] weakness 1 2 true
    execute if data storage sys: {witch_weakness:true} run execute if data entity @a[team=Witch,tag=!Sorceress] Inventory[{id:"minecraft:bow"}] run tellraw @s {"text":"弓は持てません!","color":"red"}
    execute if data storage sys: {witch_weakness:true} run execute if data entity @a[team=Witch,tag=!Sorceress] Inventory[{id:"minecraft:bow"}] run clear @s bow
    execute if data storage sys: {witch_weakness:true} run execute if data entity @a[team=Witch,tag=!Sorceress] Inventory[{id:"minecraft:arrow"}] run tellraw @s {"text":"矢は持てません!","color":"red"}
    execute if data storage sys: {witch_weakness:true} run execute if data entity @a[team=Witch,tag=!Sorceress] Inventory[{id:"minecraft:arrow"}] run clear @s arrow