data modify storage sys: return_item set from entity @s Inventory[{Slot:10b}]
clear @s carrot_on_a_stick{Tags:["settings_button"]}
item replace entity @s inventory.1 with minecraft:carrot_on_a_stick{Tags:["settings_button","no_drop"],display:{Name:'{"text":"設定を開く","italic":false,"color":"white"}'},CustomModelData:90003,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute as @s at @s run function werewolf:.system/inventory_menu/return_item
data remove storage sys: return_item
execute if data storage sys: {game_start:0} as @s[scores={inventory_menu=0,time_since_death=4..}] run function werewolf:.settings/view_settings
execute if data storage sys: {game_start:1} as @s[scores={inventory_menu=0,time_since_death=4..}] run tellraw @s "[システムアナウンス] 今は設定を変更できません。"
playsound minecraft:ui.button.click master @s[scores={inventory_menu=0,time_since_death=4..}] ~ ~ ~ 0.3