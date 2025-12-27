#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

execute at @e[type=marker,tag=chest_point,tag=this] run particle minecraft:crit ~ ~ ~ 0.8 0.8 0.8 0 1 force @a

execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.10.active set value 2
execute if data storage sys: random_event.10{active:2} run tellraw @a {"interpret":true,"nbt":"hidden_property.announce.end.1","storage":"wolf_data:"}
execute if data storage sys: random_event.10{active:2} at @e[type=marker,tag=chest_point] run data remove block ~ ~ ~ Items
execute if data storage sys: random_event.10{active:2} at @e[type=marker,tag=chest_point] run setblock ~ ~ ~ air replace
execute if data storage sys: random_event.10{active:2} at @e[type=marker,tag=chest_point,tag=this] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
execute if data storage sys: random_event.10{active:2} as @e[type=marker,tag=chest_point,tag=this] run tag @s remove this
#イベント詳細をまとめて削除
execute if data storage sys: random_event.10{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.10{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.10{active:1} run schedule function werewolf:random_event/hidden_property/.on_going 1t