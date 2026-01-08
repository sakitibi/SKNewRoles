execute store result storage item: motion double 0.001 run data get entity @s Motion[0] 1000
execute if data storage item: {motion:0d} store result entity @s Motion[0] double 0.001 run data get entity @s Item.tag.Motion[0] -300
execute store result storage item: motion double 0.001 run data get entity @s Motion[1] 1000
execute if data storage item: {motion:0d} store result entity @s Motion[1] double 0.001 run data get entity @s Item.tag.Motion[1] -300

execute store result storage item: motion double 0.001 run data get entity @s Motion[2] 1000
execute if data storage item: {motion:0d} store result entity @s Motion[2] double 0.001 run data get entity @s Item.tag.Motion[2] -300

data modify entity @s Item.tag.Motion set from entity @s Motion