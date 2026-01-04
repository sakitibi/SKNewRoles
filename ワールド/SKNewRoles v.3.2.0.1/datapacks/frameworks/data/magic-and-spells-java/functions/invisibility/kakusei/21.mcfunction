execute as @e[tag=kakusei,scores={magic1=21}] run item replace entity @s weapon.mainhand.0 with minecraft:enchanted_book 1 0
execute at @e[tag=kakusei,scores={magic1=21}] run summon bat bat ~ ~ ~
scoreboard players set @e[scores={magic1=21}] magic1 0