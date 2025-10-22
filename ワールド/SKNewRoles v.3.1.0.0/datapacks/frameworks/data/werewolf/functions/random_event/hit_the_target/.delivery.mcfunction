execute as @s[nbt=!{Inventory:[{id:"minecraft:bread"}]}] run tellraw @s {"text":"納品するものを持っていない"}
execute as @s[nbt={Inventory:[{id:"minecraft:bread"}]}] store result storage sys: random_event.6.delivery int 0.99999999 run data get storage sys: random_event.6.delivery
execute as @s[nbt={Inventory:[{id:"minecraft:bread"}]}] run clear @s bread 1

advancement revoke @s only werewolf:random_event/event_6/delivery_bread