#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

#頭上にブロックがなければ移動速度低下状態を付与
execute if score GameManager event_timer_countdown matches ..2000 run execute as @a at @s positioned over motion_blocking if entity @s[dy=999] run effect give @s[team=!Witch,team=!Blacksnowgirl,team=!Snowgirl,team=!Araregirl] slowness 1 2 true

#イベント終了処理
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.14.active set value 2
execute if data storage sys: random_event.14{active:2} run tellraw @a {"interpret":true,"nbt":"snow_storm.announce.end.1","storage":"wolf_data:"}

#イベント詳細をまとめて削除
execute if data storage sys: random_event.14{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.14{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.14{active:1} run schedule function werewolf:random_event/snow_storm/.on_going 1t