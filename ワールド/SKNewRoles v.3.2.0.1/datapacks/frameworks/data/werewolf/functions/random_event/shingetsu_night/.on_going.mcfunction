#盲目処理
execute if data storage sys: random_event.13{active:1} run execute if data storage sys: {time_query:15000} run schedule function werewolf:random_event/shingetsu_night/.blindness 1t append false
#イベント判定を進行
execute if data storage sys: random_event.13{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.13{active:1} run schedule function werewolf:random_event/shingetsu_night/.on_going 1t