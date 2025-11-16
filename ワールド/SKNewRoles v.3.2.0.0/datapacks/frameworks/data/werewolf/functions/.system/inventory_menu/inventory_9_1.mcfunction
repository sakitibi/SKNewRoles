data modify storage sys: return_item set from entity @s Inventory[{Slot:9b}]
clear @s carrot_on_a_stick{Tags:["join_button"]}
item replace entity @s inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","no_drop"],display:{Name:'{"text":"ゲームに参加","italic":false,"color":"white"}'},CustomModelData:1001,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute as @s at @s run function werewolf:.system/inventory_menu/return_item
data remove storage sys: return_item
team join Sanka @s[scores={inventory_menu=0,time_since_death=4..}]
tellraw @s[scores={inventory_menu=0,time_since_death=4..}] [{"text":"[システムアナウンス] "},{"text":"ゲームに参加します。"}]
playsound minecraft:ui.button.click master @s[scores={inventory_menu=0,time_since_death=4..}] ~ ~ ~ 0.3