execute as @s[nbt=!{Inventory:[{id:"minecraft:apple"}]}] run tellraw @s {"text":"納品するものを持っていない"}
execute as @s[nbt={Inventory:[{id:"minecraft:apple"}]}] store result storage sys: random_event.8.delivery int 0.99999999 run data get storage sys: random_event.8.delivery
execute as @s[nbt={Inventory:[{id:"minecraft:apple"}]}] run clear @s apple 1

#納品箱の見た目更新
execute if data storage sys: random_event.8{delivery:9} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_apple,sort=nearest,limit=1] {item:{tag:{CustomModelData:4}}}
execute if data storage sys: random_event.8{delivery:7} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_apple,sort=nearest,limit=1] {item:{tag:{CustomModelData:5}}}
execute if data storage sys: random_event.8{delivery:4} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_apple,sort=nearest,limit=1] {item:{tag:{CustomModelData:6}}}
execute if data storage sys: random_event.8{delivery:1} at @e[type=marker,tag=delivery_box] run data merge entity @e[type=item_display,tag=delivery_apple,sort=nearest,limit=1] {item:{tag:{CustomModelData:7}}}

advancement revoke @s only werewolf:random_event/event_8/delivery_apple