#アイテムを配布
function werewolf:.system/treasure_chest/give_item
#チェストを削除
#execute as @e[type=interaction,tag=treasure_chest] if data entity @s interaction.player at @s run kill @e[type=item_display,tag=treasure_chest,distance=..1]
#execute as @e[type=interaction,tag=treasure_chest] if data entity @s interaction.player at @s run particle minecraft:cloud ~ ~0.5 ~ 0.5 0.5 0.5 0 3 force @a
#execute as @e[type=interaction,tag=treasure_chest] if data entity @s interaction.player run kill @s


#animated_java用
execute as @e[type=interaction,tag=treasure_chest] if data entity @s interaction.player at @s as @e[type=#Adv_Map_Creator_data:animated_java/root,tag=aj.treasure_chest.root,sort=nearest,limit=1] run function Adv_Map_Creator_data:animated_java/treasure_chest/animations/open/play
execute as @e[type=interaction,tag=treasure_chest] if data entity @s interaction.player run kill @s

execute as @s at @s run playsound minecraft:open_chest master @a

advancement revoke @s only werewolf:treasure_chest/interaction_treasure_chest