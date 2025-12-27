data modify storage sys: return_item set from entity @s Inventory[{Slot:11b}]
clear @s carrot_on_a_stick{Tags:["game_start_button"]}
scoreboard players add @s ready 0

execute if data storage sys: {game_start:0} run item replace entity @s[scores={ready=0}] inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了を取り消し","italic":false,"color":"white"}'},CustomModelData:90004,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute if data storage sys: {game_start:0} run item replace entity @s[scores={ready=1}] inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了","italic":false,"color":"white"}'},CustomModelData:90005,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
#execute if data storage sys: {game_start:1} run item replace entity @s[scores={ready=1}] inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了","italic":false,"color":"white"}'},CustomModelData:90005,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
#execute if data storage sys: {game_start:1} run item replace entity @s[scores={ready=0}] inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了を取り消し","italic":false,"color":"white"}'},CustomModelData:90004,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute if data storage sys: {game_start:1} run item replace entity @s inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了を取り消し","italic":false,"color":"white"}'},CustomModelData:90004,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}

execute as @s at @s run function werewolf:.system/inventory_menu/return_item
data remove storage sys: return_item
execute if data storage sys: {game_start:0} as @s[scores={ready=0}] run scoreboard players add @s ready 2

#準備完了取り消し
execute if data storage sys: {game_start:0} as @s[scores={inventory_menu=0,time_since_death=4..,ready=1}] run tellraw @s [{"text":"[システムアナウンス] "},{"text":"準備完了を取り消しました。"}]
execute if data storage sys: {game_start:0} as @s[scores={inventory_menu=0,time_since_death=4..,ready=1}] run scoreboard players set @s ready 0
#準備完了
execute if data storage sys: {game_start:0} as @s[scores={inventory_menu=0,time_since_death=4..,ready=2}] unless entity @a[scores={ready=0}] run tellraw @s [{"text":"[システムアナウンス] "},{"text":"ゲームを開始します…"}]
execute if data storage sys: {game_start:0} as @s[scores={inventory_menu=0,time_since_death=4..,ready=2}] if entity @a[scores={ready=0}] run tellraw @s [{"text":"[システムアナウンス] "},{"text":"他プレイヤーを待っています…"}]
execute if data storage sys: {game_start:0} as @s[scores={inventory_menu=0,time_since_death=4..,ready=2}] run scoreboard players set @s ready 1

execute if data storage sys: {game_start:1} as @s[scores={inventory_menu=0,time_since_death=4..}] run tellraw @s "[システムアナウンス] 今は準備完了を取り消すことができません。"

playsound minecraft:ui.button.click master @s[scores={inventory_menu=0,time_since_death=4..}] ~ ~ ~ 0.3