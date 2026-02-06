#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

#イベント終了処理
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.3.active set value 2
execute unless entity @e[type=salmon,tag=event_salmon] unless data storage sys: random_event.3{active:9} run data modify storage sys: random_event.3.active set value 2
execute if data storage sys: random_event.3{active:2} run tellraw @a {"interpret":true,"nbt":"falling_salmon.announce.end.1","storage":"wolf_data:"}

#デスポーンの演出
execute if data storage sys: random_event.3{active:2} run execute at @e[type=salmon,tag=event_salmon] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#デスポーン
execute if data storage sys: random_event.3{active:2} run tp @e[type=salmon,tag=event_salmon] ~ ~-1000 ~
execute if data storage sys: random_event.3{active:2} run kill @e[type=salmon,tag=event_salmon]

#イベント詳細をまとめて削除
execute if data storage sys: random_event.3{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.3{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.3{active:1} run schedule function werewolf:random_event/falling_salmon/.on_going 1t