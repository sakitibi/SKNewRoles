kill @e[type=!marker,tag=ice_sword]
execute at @e[type=marker,tag=ice_sword] run summon item_display ~ ~0.5 ~ {Tags:["event","ice_sword"],item:{id:"minecraft:carrot_on_a_stick",Count:1b,tag:{CustomModelData:99996}},Rotation:[137.828f,18.9f]}
execute at @e[type=marker,tag=ice_sword] run summon interaction ~ ~ ~ {Tags:["event","ice_sword"],height:1.5f,width:0.3f}