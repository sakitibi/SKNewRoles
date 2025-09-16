data modify storage sys: return_item set from entity @s Inventory[{Slot:9b}]
clear @s carrot_on_a_stick{Tags:["join_button"]}
execute if data storage sys: {game_start:0} run item replace entity @s[team=Sanka] inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","sanka","no_drop"],display:{Name:'{"text":"ゲームモード変更","italic":false,"color":"white"}',Lore:['{"text":" 現在の状態: ゲームを観戦","color":"gray","italic":false}']},CustomModelData:90002,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute if data storage sys: {game_start:0} run item replace entity @s[team=Fusanka] inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","fusanka","no_drop"],display:{Name:'{"text":"ゲームモード変更","italic":false,"color":"white"}',Lore:['{"text":" 現在の状態: ゲームに参加","color":"gray","italic":false}']},CustomModelData:90001,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute if data storage sys: {game_start:1} run item replace entity @s[team=Fusanka] inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","sanka","no_drop"],display:{Name:'{"text":"ゲームモード変更","italic":false,"color":"white"}',Lore:['{"text":" 現在の状態: ゲームを観戦","color":"gray","italic":false}']},CustomModelData:90002,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}
execute if data storage sys: {game_start:1} run item replace entity @s[team=Sanka] inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","fusanka","no_drop"],display:{Name:'{"text":"ゲームモード変更","italic":false,"color":"white"}',Lore:['{"text":" 現在の状態: ゲームに参加","color":"gray","italic":false}']},CustomModelData:90001,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}],HideFlags:63}


execute as @s at @s run function werewolf:.system/inventory_menu/return_item
data remove storage sys: return_item

scoreboard players set @s time_since_death 0
#準備完了取り消し
execute if data storage sys: {game_start:0} as @s[team=Fusanka,scores={inventory_menu=0,time_since_death=0}] run tellraw @s [{"text":"[システムアナウンス] "},{"text":"ゲームに参加します。"}]
execute if data storage sys: {game_start:0} as @s[team=Fusanka,scores={inventory_menu=0,time_since_death=0}] run scoreboard players set @s time_since_death 4
execute if data storage sys: {game_start:0} as @s[team=Fusanka,scores={inventory_menu=0,time_since_death=4}] run team join Sanka
#準備完了
execute if data storage sys: {game_start:0} as @s[team=Sanka,scores={inventory_menu=0,time_since_death=0}] run tellraw @s [{"text":"[システムアナウンス] "},{"text":"ゲームを観戦します。"}]
execute if data storage sys: {game_start:0} as @s[team=Sanka,scores={inventory_menu=0,time_since_death=0}] run team join Fusanka
execute if data storage sys: {game_start:0} as @s[team=Fusanka,scores={inventory_menu=0,time_since_death=0}] run scoreboard players set @s time_since_death 4

execute if data storage sys: {game_start:1} as @s[scores={inventory_menu=0,time_since_death=0}] run tellraw @s "[システムアナウンス] 今はゲームモードを変更できません。"

playsound minecraft:ui.button.click master @s[scores={inventory_menu=0,time_since_death=4..}] ~ ~ ~ 0.3