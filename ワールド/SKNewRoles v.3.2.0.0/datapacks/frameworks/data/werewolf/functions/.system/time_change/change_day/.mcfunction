execute unless score GameManager common_timer matches -1 run tellraw @a {"text":"[システムアナウンス] もうすぐ夜が明ける…"}

execute unless score GameManager common_timer matches -1 run scoreboard players set GameManager common_timer -1

time add 100
execute store result storage sys: time_query int 1 run time query daytime

# 制限時間の設定
execute if data storage sys: {time_query:6000} run data modify storage sys: time_phase set value day
execute if data storage sys: {time_query:6000} run scoreboard players add GameManager day 1
execute if data storage sys: {time_query:6000} run data modify storage sys: time_text set value '{"text":"昼時間","color":"white"}'
#execute if data storage sys: {time_query:6000} run data modify storage sys: time_text set value '{"text":"\\uF804\\uF804\\uF804昼時間\\uF804\\uF804\\uF804","color":"white"}'
execute if data storage sys: {time_query:6000} run scoreboard players operation GameManager common_timer = GameManager set_daytime
execute if data storage sys: {time_query:6000} run bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]
#execute if data storage sys: {time_query:6000} run bossbar set time_bossbar name [{"text":"\uF804\uF804\uF804\uF804\uF804\uF804"},{"score":{"name":"GameManager","objective":"day"},"font":"default_negative"},{"interpret":true,"nbt":"time_text","storage":"sys:"},{"text":" ["},{"score":{"name":"GameManager","objective":"day"}},{"text":"日目]"},{"score":{"name":"GameManager","objective":"day"},"font":"default_negative"},{"text":"\uF804\uF804\uF804\uF804\uF804\uF804"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"},{"interpret":true,"nbt":"random_event.bar","storage":"sys:"}]
execute if data storage sys: {time_query:6000} run execute store result bossbar time_bossbar max run scoreboard players get GameManager set_daytime
execute if data storage sys: {time_query:6000} run execute store result bossbar time_bossbar value run scoreboard players get GameManager common_timer

# ランダムイベントを有効化
execute if data storage sys: {time_query:6000} if data storage sys: {event_active:0} run scoreboard players set GameManager event_timer 1000

# 門が閉まっていれば開ける
execute if data storage sys: {time_query:6000} if data storage sys: random_event.1{gate:close} run function werewolf:random_event/monster_stampede/gate_anim/.open_main

# スキルのカウント等進行
# スキル回復
function werewolf:.system/time_change/change_day/mura
function werewolf:.system/time_change/change_day/jinrou
function werewolf:.system/time_change/change_day/other
#パン屋処理
execute if data storage sys: {time_query:6000} if entity @a[team=Panya,tag=player] run function werewolf:role/work_panya/.panya
execute if data storage sys: {time_query:6000} if entity @a[team=Witch,tag=player,tag=!Sorceress] run function werewolf:role/work_witch/.witch
execute if data storege sys: {time_query:6000} if entity @a[team=Syachou,tag=player] run function werewolf:role/work_syachou/.syachou
execute if data storege sys: {time_query:6000} if entity @a[team=Satsumatoimo] run function werewolf:role/work_satsumatoimo/.satsumatoimo

# 夜タスク削除
execute if data storage sys: {time_query:6000} run function werewolf:task/night_task/remove_task

# タスク再設置
execute if data storage sys: {time_query:6000} run function werewolf:task/set_task

# ランダムチェスト再設置
execute if data storage sys: {time_query:6000} run function werewolf:.system/treasure_chest/kill_all_treasure_chest
execute if data storage sys: {time_query:6000} run function werewolf:.system/treasure_chest/set_treasure_chest

# イベントの個別処理
execute if data storage sys: {time_query:6000} as @a[predicate=werewolf:random_chance/rot_apple] run function werewolf:random_event/delivery_apple/rot_fruit

# 裁判官による招集
execute if data storage sys: {time_query:6000} if entity @a[tag=player,team=Saibankan] run function werewolf:skill/skill_saibankan/.trial
execute if data storage sys: {time_query:6000} unless entity @a[tag=player,team=Saibankan] if entity @a[tag=player,tag=saibankan_1] run function werewolf:skill/skill_saibankan/.trial


#再帰処理
execute if data storage sys: {game_phase:1} unless data storage sys: {time_query:6000} run schedule function werewolf:.system/time_change/change_day 1t append false