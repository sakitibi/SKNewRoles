#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

#テレポート処理
execute if score GameManager event_timer_countdown matches 0 run function werewolf:random_event/random_teleport/.teleport
#イベント終了処理
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.7.active set value 2
execute if data storage sys: random_event.7{active:2} run tellraw @a {"interpret":true,"nbt":"random_teleport.announce.end.1","storage":"wolf_data:"}


#イベント詳細をまとめて削除
execute if data storage sys: random_event.7{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.7{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.7{active:1} run schedule function werewolf:random_event/random_teleport/.on_going 1t