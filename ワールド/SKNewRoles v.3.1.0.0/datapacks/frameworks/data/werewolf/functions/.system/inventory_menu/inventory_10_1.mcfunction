data modify storage sys: return_item set from entity @s Inventory[{Slot:10b}]
clear @s carrot_on_a_stick{Tags:["not_join_button"]}
item replace entity @s inventory.1 with minecraft:carrot_on_a_stick{Tags:["not_join_button","no_drop"],display:{Name:'{"text":"ゲームを観戦","italic":false,"color":"white"}'},CustomModelData:1002,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute as @s at @s run function werewolf:.system/inventory_menu/return_item
data remove storage sys: return_item
team join Fusanka @s[scores={inventory_menu=0,time_since_death=4..}]
tellraw @s[scores={inventory_menu=0,time_since_death=4..}] [{"text":"[システムアナウンス] "},{"text":"ゲームを観戦します。"}]
playsound minecraft:ui.button.click master @s[scores={inventory_menu=0,time_since_death=4..}] ~ ~ ~ 0.3