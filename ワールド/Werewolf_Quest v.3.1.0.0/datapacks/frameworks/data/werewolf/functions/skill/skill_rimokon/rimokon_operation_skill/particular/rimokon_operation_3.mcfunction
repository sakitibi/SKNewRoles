# マーキングしていない時の処理
execute unless entity @a[tag=marking,team=!Tenkai] run tellraw @a[team=Rimokon,tag=3] "今は使えない"

# マーキングした後の処理
execute if entity @a[tag=marking,team=!Tenkai] run tag @a[team=Rimokon,tag=3] add useoperation
execute at @a[tag=useoperation,tag=3] at @s run tellraw @s "操作開始！"
execute at @a[tag=useoperation,tag=3] at @s run summon armorstand ~ ~ ~ operation
execute if entity @a[tag=useoperation,tag=3] run tp @s @a[tag=marking,team=!Tenkai]
effect give @a[tag=marking] resistance 30 4 true
effect give @a[tag=useoperation,tag=3] resistance 30 4 true
effect give @a[tag=useoperation,tag=3] invisibility 30 255 true
effect give @e[name=operation] resistance 30 4 true
effect give @e[name=operation] invisibility 30 4 true
execute if entity @a[tag=marking,team=!Tenkai] run tag @a[team=Rimokon,tag=3,tag=useoperation] remove useoperation
execute if entity @a[tag=marking,team=!Tenkai] run tp @s @a[team=Rimokon,tag=operation,tag=3]
scoreboard players add @a[team=Rimokon,tag=3,scores={RimokonOperationTimes=..600}] RimokonOperationTimes 1

# 操作解除 時間切れ
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3,tag=operation] at @s run tag @s remove operation
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run tp @s @e[name=operation]
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] run kill @e[name=operation]
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run effect clear @s invisibility
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run effect clear @s resistance
execute if entity @a[tag=marking,team=!Tenkai] at @s run effect clear @s resistance
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run effect clear @e[name=operation] invisibility
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run effect clear @e[name=operation] resistance
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run tellraw @s "時間切れだ、"
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] run tag @a[tag=marking,team=!Tenkai] remove marking
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run scoreboard players reset @s RimokonOperationTimes
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] run kill @e[type=armorstand,name=operation]

# 操作解除 キルした時
execute unless entity @a[tag=marking,team=!Tenkai] run tag @a[team=Rimokon,tag=operation,tag=3] remove operation
execute unless entity @a[tag=marking,team=!Tenkai] run tp @a[scores={RimokonOperationTimes=..600}] @e[name=operation]
execute unless entity @a[tag=marking,team=!Tenkai] run kill @e[name=operation]
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear sa[scores={RimokonOperationTimes=..600},tag=3] invisibility
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear @a[scores={RimokonOperationTimes=..600},tag=3] resistance
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear @e[name=operation] invisibility
execute unless entity @a[tag=marking,team=!Tenkai] run effect clear @e[name=operation] resistance
execute if entity @a[team=Rimokon,scores={RimokonOperationTimes=600..},tag=3] at @s run tellraw @s "操作中にキルした！"
execute if entity @a[tag=marking,team=Tenkai] at @s run effect clear @s resistance
execute unless entity @a[tag=marking,team=!Tenkai] run scoreboard players reset @a[scores={RimokonOperationTimes=..600}] RimokonOperationTimes
execute if entity @a[tag=marking,team=Tenkai] at @s run tag @s remove marking
execute unless entity @a[tag=marking,team=!Tenkai] run kill @e[type=armorstand,name=operation]