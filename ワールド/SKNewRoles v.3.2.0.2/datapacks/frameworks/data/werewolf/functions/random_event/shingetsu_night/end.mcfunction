#イベント終了処理
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.13.active set value 2
execute if score GameManager glowing_successed matches 1 run execute if data storage sys: random_event.13{active:2} run tellraw @a {"interpret":true,"nbt":"shingetsu_night.announce.success.1","storage":"wolf_data:"}
execute unless score GameManager glowing_successed matches 1 run execute if data storage sys: random_event.13{active:2} run tellraw @a {"interpret":true,"nbt":"shingetsu_night.announce.end.1","storage":"wolf_data:"}
#イベント詳細をまとめて削除
execute if data storage sys: random_event.13{active:2} run schedule function werewolf:random_event/event_clear 1s