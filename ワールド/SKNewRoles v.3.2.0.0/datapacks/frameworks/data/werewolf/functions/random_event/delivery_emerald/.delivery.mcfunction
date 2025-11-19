execute as @s[nbt=!{Inventory:[{id:"minecraft:emerald"}]}] run tellraw @s {"text":"納品するものを持っていない"}
execute as @s[nbt={Inventory:[{id:"minecraft:emerald"}]}] store result storage sys: random_event.12.delivery int 0.99999999 run data get storage sys: random_event.12.delivery
execute as @s[nbt={Inventory:[{id:"minecraft:emerald"}]}] run clear @s emerald 1

#納品箱の見た目更新
execute if data storage sys: random_event.12{delivery:9} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_emerald,sort=nearest,limit=1] {item:{tag:{CustomModelData:3}}}
execute if data storage sys: random_event.12{delivery:7} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_emerald,sort=nearest,limit=1] {item:{tag:{CustomModelData:4}}}
execute if data storage sys: random_event.12{delivery:5} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_emerald,sort=nearest,limit=1] {item:{tag:{CustomModelData:5}}}
execute if data storage sys: random_event.12{delivery:2} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_emerald,sort=nearest,limit=1] {item:{tag:{CustomModelData:6}}}


advancement revoke @s only werewolf:random_event/event_12/delivery_emerald