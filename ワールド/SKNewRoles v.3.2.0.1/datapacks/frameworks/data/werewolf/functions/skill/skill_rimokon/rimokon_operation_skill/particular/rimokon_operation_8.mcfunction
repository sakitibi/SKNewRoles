# マーキングしていない時の処理
execute unless entity @a[tag=marking,team=!Tenkai] run tellraw @a[team=Rimokon,tag=8] "今は使えない"

# マーキングした後の処理
execute if entity @a[tag=marking,team=!Tenkai] run tag @a[team=Rimokon,tag=8] add useoperation
execute at @a[tag=useoperation,tag=8] at @s run tellraw @s "操作開始！"
execute at @a[tag=useoperation,tag=8] at @s run summon armorstand ~ ~ ~ operation
execute if entity @a[tag=useoperation,tag=8] run tp @s @a[tag=marking,team=!Tenkai]
effect give @a[tag=marking] resistance 30 4 true
effect give @a[tag=useoperation,tag=8] resistance 30 4 true
effect give @a[tag=useoperation,tag=8] invisibility 30 255 true
effect give @e[name=operation] resistance 30 4 true
effect give @e[name=operation] invisibility 30 4 true
execute if entity @a[tag=marking,team=!Tenkai] run tag @a[team=Rimokon,tag=8,tag=useoperation] remove useoperation
execute if entity @a[tag=marking,team=!Tenkai] run tp @s @a[team=Rimokon,tag=operation,tag=8]
scoreboard players add @a[team=Rimokon,tag=8,scores={RimokonOperationTimes=..600}] RimokonOperationTimes 1

# 操作解除 時間切れ
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8,tag=operation] at @s run tag @s remove operation
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run tp @s @e[name=operation]
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] run kill @e[name=operation]
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run effect clear @s invisibility
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run effect clear @s resistance
execute if entity @a[tag=marking,team=!Tenkai] at @s run effect clear @s resistance
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run effect clear @e[name=operation] invisibility
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run effect clear @e[name=operation] resistance
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run tellraw @s "時間切れだ、"
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] run tag @a[tag=marking,team=!Tenkai] remove marking
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run scoreboard players reset @s RimokonOperationTimes
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] run kill @e[type=armorstand,name=operation]

# 操作解除 キルした時
execute unless entity @a[tag=marking,team=!Tenkai] run tag @a[team=Rimokon,tag=operation,tag=8] remove operation
execute unless entity @a[tag=marking,team=!Tenkai] run tp @a[scores={RimokonOperationTimes=..600}] @e[name=operation]
execute unless entity @a[tag=marking,team=!Tenkai] run kill @e[name=operation]
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear sa[scores={RimokonOperationTimes=..600},tag=8] invisibility
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear @a[scores={RimokonOperationTimes=..600},tag=8] resistance
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear @e[name=operation] invisibility
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear @e[name=operation] resistance
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=8] at @s run tellraw @s "操作中にキルした！"
execute if entity @a[tag=marking,team=Tenkai] at @s run effect clear @s resistance
execute unless entity @a[tag=marking,team=!Tenkai] run scoreboard players reset @a[scores={RimokonOperationTimes=..600}] RimokonOperationTimes
execute if entity @a[tag=marking,team=Tenkai] at @s run tag @s remove marking
execute unless entity @a[tag=marking,team=!Tenkai] run kill @e[type=armorstand,name=operation]