execute unless score GameManager common_timer matches -1 run tellraw @a {"text":"[システムアナウンス] もうすぐ夜が訪れる…"}

execute unless score GameManager common_timer matches -1 run scoreboard players set GameManager common_timer -1

time add 100
execute store result storage sys: time_query int 1 run time query daytime

# 制限時間の設定
execute if data storage sys: {time_query:15000} run data modify storage sys: time_phase set value night
execute if data storage sys: {time_query:15000} run data modify storage sys: time_text set value '{"text":"夜時間","color":"white"}'
execute if data storage sys: {time_query:15000} run scoreboard players operation GameManager common_timer = GameManager set_nighttime
execute if data storage sys: {time_query:15000} run bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]
#execute if data storage sys: {time_query:15000} run bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"},{"interpret":true,"nbt":"random_event.bar","storage":"sys:"}]
execute if data storage sys: {time_query:15000} run execute store result bossbar time_bossbar max run scoreboard players get GameManager set_nighttime
execute if data storage sys: {time_query:15000} run execute store result bossbar time_bossbar value run scoreboard players get GameManager common_timer

# ランダムイベントを無効化
execute if data storage sys: {time_query:15000} run scoreboard players set GameManager event_timer -2

# 夜のタスクを設置
execute if data storage sys: {time_query:15000} run function werewolf:task/night_task/set_task

#再帰処理
execute if data storage sys: {game_phase:1} unless data storage sys: {time_query:15000} run schedule function werewolf:.system/time_change/change_night 1t