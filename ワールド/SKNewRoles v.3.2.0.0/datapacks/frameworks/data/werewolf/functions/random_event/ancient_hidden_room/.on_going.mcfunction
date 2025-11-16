#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

execute at @e[type=marker,tag=hidden_wall_opener] run particle minecraft:crit ~ ~ ~ 0.2 1 0.2 0 10 force @a

execute at @e[type=marker,tag=hidden_wall_opener] as @a[gamemode=!spectator,distance=..0.7] run title @s actionbar "その場で待機する(残り1人)"


execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.11.active set value 2
execute if data storage sys: random_event.11{active:2} run title @a title {"interpret":true,"nbt":"quest_failed","storage":"wolf_data:"}
execute if data storage sys: random_event.11{active:2} run tellraw @a {"interpret":true,"nbt":"ancient_hidden_room.announce.failed.1","storage":"wolf_data:"}

execute at @e[type=marker,tag=hidden_wall_opener_1] if entity @a[gamemode=!spectator,distance=..0.8] at @e[type=marker,tag=hidden_wall_opener_2] if entity @a[gamemode=!spectator,distance=..0.8] run data modify storage sys: random_event.11.active set value 3
execute if data storage sys: random_event.11{active:3} run title @a title {"interpret":true,"nbt":"quest_success","storage":"wolf_data:"}
execute if data storage sys: random_event.11{active:3} run tellraw @a {"interpret":true,"nbt":"ancient_hidden_room.announce.success.1","storage":"wolf_data:"}
execute if data storage sys: random_event.11{active:3} run function werewolf:random_event/ancient_hidden_room/hidden_wall/open


#おかたづけ
#execute unless data storage sys: random_event.11{active:1} run kill @e[tag=event]
#氷剣を光らせる
execute unless data storage sys: random_event.11{active:1} run data modify entity @e[type=minecraft:item_display,tag=ice_sword,limit=1] Glowing set value false

#イベント詳細をまとめて削除
execute unless data storage sys: random_event.11{active:1} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute unless data storage sys: random_event.11{active:1} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.11{active:1} run schedule function werewolf:random_event/ancient_hidden_room/.on_going 1t

#summon marker ~ ~ ~ {Tags:["hidden_wall_opener","hidden_wall_opener_1"]}
#summon marker ~ ~ ~ {Tags:["hidden_wall_opener","hidden_wall_opener_2"]}
