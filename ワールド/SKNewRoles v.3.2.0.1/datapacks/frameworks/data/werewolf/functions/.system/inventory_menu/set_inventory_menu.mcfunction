scoreboard players set @s inventory_menu 1
scoreboard players set @s time_since_death 0

#9
execute as @s[team=!Sanka,team=!Fusanka] run team join Fusanka
execute as @s[team=!Sanka] run item replace entity @s inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","no_drop"],display:{Name:'{"text":"ゲームモード変更","italic":false,"color":"white"}',Lore:['{"text":" 現在の状態: ゲームを観戦","color":"gray","italic":false}']},HideFlags:63,CustomModelData:90002,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}
execute as @s[team=Sanka] run item replace entity @s inventory.0 with minecraft:carrot_on_a_stick{Tags:["join_button","no_drop"],display:{Name:'{"text":"ゲームモード変更","italic":false,"color":"white"}',Lore:['{"text":" 現在の状態: ゲームに参加","color":"gray","italic":false}']},HideFlags:63,CustomModelData:90001,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}

#10
item replace entity @s inventory.1 with minecraft:carrot_on_a_stick{Tags:["settings_button","no_drop"],display:{Name:'{"text":"設定を開く","italic":false,"color":"white"}'},HideFlags:63,CustomModelData:90003,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}

#11
execute unless score @s ready matches 0 unless score @s ready matches 1 run scoreboard players set @s ready 0
execute as @s run item replace entity @s inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了","italic":false,"color":"white"}'},HideFlags:63,CustomModelData:90005,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}
execute as @s[scores={ready=1}] run item replace entity @s inventory.2 with minecraft:carrot_on_a_stick{Tags:["game_start_button","no_drop"],display:{Name:'{"text":"準備完了を取り消し","italic":false,"color":"white"}'},HideFlags:63,CustomModelData:90004,Enchantments:[{id:"minecraft:vanishing_curse",lvl:1s}]}


item replace entity @a armor.head with minecraft:carrot_on_a_stick{display:{Name:'{"text":""}'},HideFlags:63,CustomModelData:90000,Enchantments:[{id:"minecraft:binding_curse",lvl:1s},{id:"minecraft:vanishing_curse",lvl:1s}]}

scoreboard players set @s inventory_menu 0


