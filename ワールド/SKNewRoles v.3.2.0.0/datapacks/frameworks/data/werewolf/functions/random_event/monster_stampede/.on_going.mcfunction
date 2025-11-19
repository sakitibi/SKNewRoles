#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

#タイムアップ
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.1.active set value 3
execute if data storage sys: random_event.1{active:3} run title @a title {"interpret":true,"nbt":"quest_failed","storage":"wolf_data:"}
execute if data storage sys: random_event.1{active:3} run tellraw @a {"interpret":true,"nbt":"monster_stampede.announce.failed.1","storage":"wolf_data:"}
#おかたづけ
#発光を消灯
execute if data storage sys: random_event.1{active:3} run execute at @e[type=marker,tag=re_button_1] align xyz run data merge entity @e[type=item_display,tag=re_button_1,sort=nearest,limit=1] {Glowing:false}
execute if data storage sys: random_event.1{active:3} run execute at @e[type=marker,tag=re_button_2] align xyz run data merge entity @e[type=item_display,tag=re_button_2,sort=nearest,limit=1] {Glowing:false}
#ペナルティ設定
execute if data storage sys: random_event.1{active:3} run function werewolf:random_event/monster_stampede/.schedule_penalty

#イベントの終了フラグ
execute if data storage sys: random_event.1{active:3} run data modify storage sys: random_event.1.active set value 0

#ボタンの同時押しでイベント終了処理
execute if data storage sys: random_event.1{active:1,button_1:1,button_2:1} run title @a title {"interpret":true,"nbt":"quest_success","storage":"wolf_data:"}
execute if data storage sys: random_event.1{active:1,button_1:1,button_2:1} run tellraw @a {"interpret":true,"nbt":"monster_stampede.announce.success.1","storage":"wolf_data:"}
execute if data storage sys: random_event.1{active:1,button_1:1,button_2:1} run function werewolf:random_event/monster_stampede/.clear

#イベント詳細をまとめて削除
execute unless data storage sys: random_event.1{active:1} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute unless data storage sys: random_event.1{active:1} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.1{active:1} unless data storage sys: random_event.1{button_1:1,button_2:1} run schedule function werewolf:random_event/monster_stampede/.on_going 1t
