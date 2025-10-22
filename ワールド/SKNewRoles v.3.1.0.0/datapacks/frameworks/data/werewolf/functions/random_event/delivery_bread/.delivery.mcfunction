execute as @s[nbt=!{Inventory:[{id:"minecraft:bread"}]}] run tellraw @s {"text":"納品するものを持っていない"}
execute as @s[nbt={Inventory:[{id:"minecraft:bread"}]}] store result storage sys: random_event.6.delivery int 0.99999999 run data get storage sys: random_event.6.delivery
execute as @s[nbt={Inventory:[{id:"minecraft:bread"}]}] run clear @s bread 1

#納品箱の見た目更新
execute if data storage sys: random_event.6{delivery:9} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_bread,sort=nearest,limit=1] {item:{tag:{CustomModelData:3}}}
execute if data storage sys: random_event.6{delivery:7} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_bread,sort=nearest,limit=1] {item:{tag:{CustomModelData:4}}}
execute if data storage sys: random_event.6{delivery:5} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_bread,sort=nearest,limit=1] {item:{tag:{CustomModelData:5}}}
execute if data storage sys: random_event.6{delivery:2} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_bread,sort=nearest,limit=1] {item:{tag:{CustomModelData:6}}}


advancement revoke @s only werewolf:random_event/event_6/delivery_bread 