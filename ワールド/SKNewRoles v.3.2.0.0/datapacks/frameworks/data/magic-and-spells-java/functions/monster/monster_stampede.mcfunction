scoreboard objectives add Lv1 dummy
scoreboard objectives add Lv2 dummy
scoreboard objectives add Lv3 dummy
scoreboard objectives add Kill dummy
scoreboard players random @e[type=witch] Lv1 0 350
scoreboard players random @e[type=witch] Lv2 0 300
scoreboard players random @e[type=witch] Lv3 0 250
scoreboard players random @e[type=witch] Kill 0 3000

#Witch Lv.1
execute if entity @e[name=Witch Lv.1] at @s run effect give @s speed 1 2 true
execute if entity @e[name=Witch Lv.1] at @s run effect give @s regeneration 1 0 true
execute if entity @e[name=Witch Lv.1] at @s run effect give @s resistance 1 1 true

execute if entity @e[name=Witch Lv.1,scores={Lv1=10}] at @s run function werewolf:item/blindness_tool/blindness_tool
execute if entity @e[name=Witch Lv.1,scores={Lv1=20}] at @s run effect give @a[tag=no_jinrou] wither 10 0 true
execute if entity @e[name=Witch Lv.1,scores={Lv1=30}] at @s run effect give @a[team=Witch] instant_health 1 255 true
execute if entity @e[name=Witch Lv.1,scores={Lv1=40}] at @s run effect give @a[team=!Witch] slowness 10 255 true

#Witch Lv.2
execute if entity @e[name=Witch Lv.2] at @s run effect give @s speed 1 3 true
execute if entity @e[name=Witch Lv.2] at @s run effect give @s regeneration 1 1 true
execute if entity @e[name=Witch Lv.2] at @s run effect give @s resistance 1 2 true

execute if entity @e[name=Witch Lv.2,scores={Lv2=0}] at @s run effect give @s invisibility 10 255
execute if entity @e[name=Witch Lv.2,scores={Lv2=0}] at @s run playsound minecraft:Phantom1 master @s ~ ~ ~ 0.3
execute if entity @e[name=Witch Lv.2,scores={Lv2=10}] at @s run function werewolf:item/blindness_tool/blindness_tool
execute if entity @e[name=Witch Lv.2,scores={Lv2=20}] at @s run effect give @a[tag=no_jinrou] wither 15 0 true
execute if entity @e[name=Witch Lv.2,scores={Lv2=30}] at @s run effect give @a[tag=!no_jinrou] instant_health 1 255 true
execute if entity @e[name=Witch Lv.2,scores={Lv2=40}] at @s run effect give @a[tag=no_jinrou] slowness 10 255 true
execute if entity @e[name=Witch Lv.2,scores={Kill=0}] at @s run effect give @r poison 1 255 true

#Witch Lv.3
execute if entity @e[name=Witch Lv.3] at @s run effect give @s speed 1 4 true
execute if entity @e[name=Witch Lv.3] at @s run effect give @s regeneration 1 2 true
execute if entity @e[name=Witch Lv.3] at @s run effect give @s resistance 1 3 true

execute if entity @e[name=Witch Lv.3,scores={Lv3=0}] at @s run effect give @s invisibility 10 255 true
execute if entity @e[name=Witch Lv.3,scores={Lv3=0}] at @s run playsound minecraft:Phantom1 master @s ~ ~ ~ 0.3
execute if entity @e[name=Witch Lv.3,scores={Lv3=10}] at @s run function werewolf:item/blindness_tool/blindness_tool
execute if entity @e[name=Witch Lv.3,scores={Lv3=20}] at @s run effect give @a[tag=no_jinrou] wither 15 1 true
execute if entity @e[name=Witch Lv.3,scores={Lv3=30}] at @s run effect give @a[tag=!no_jinrou] instant_health 1 255 true
execute if entity @e[name=Witch Lv.3,scores={Lv3=30}] at @s run effect give @e[type=witch] instant_health 1 255 true
execute if entity @e[name=Witch Lv.3,scores={Lv3=40}] at @s run effect give @a[tag=!camp_red] slowness 10 255 true
execute if entity @e[name=Witch Lv.3,scores={Kill=0}] at @s run kill @r[tag=no_jinrou]