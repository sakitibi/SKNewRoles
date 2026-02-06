time set 3000
data modify storage sys: time_phase set value day
data modify storage sys: time_text set value '{"text":"初日の昼時間","color":"white"}'
# ボスバーの設定

scoreboard players operation GameManager common_timer = GameManager set_first_daytime
bossbar add time_bossbar [{"text":"\uF804\uF804\uF804\uF804\uF804\uF804"},{"interpret":true,"nbt":"time_text","storage":"sys:"},{"text":"\uF804\uF804\uF804\uF804\uF804\uF804"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"},{"interpret":true,"nbt":"random_event.bar","storage":"sys:"}]
execute store result bossbar time_bossbar max run scoreboard players get GameManager set_first_daytime
execute store result bossbar time_bossbar value run scoreboard players get GameManager common_timer
bossbar set time_bossbar players @a