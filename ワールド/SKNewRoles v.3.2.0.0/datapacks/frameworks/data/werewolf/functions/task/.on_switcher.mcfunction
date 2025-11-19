#execute positioned ^ ^ ^3 as @e[type=interaction,distance=..4,tag=switcher,limit=1,sort=nearest] run scoreboard players set @s can_mining 20
#execute positioned ^ ^ ^3 as @e[type=interaction,distance=..4,tag=switcher,limit=1,sort=nearest] run data modify entity @s width set value 0.99
#execute positioned ^ ^ ^3 as @e[type=interaction,distance=..4,tag=switcher,limit=1,sort=nearest] run data modify entity @s height set value 0.99

scoreboard players set @s can_mining 25
execute if data entity @s SelectedItem{id:"minecraft:iron_pickaxe"} run item modify entity @s weapon.mainhand werewolf:item/tool/set_pickaxe_can_destroy
execute if data entity @s SelectedItem{id:"minecraft:iron_axe"} run item modify entity @s weapon.mainhand werewolf:item/tool/set_axe_can_destroy
advancement revoke @s only werewolf:task/switcher 