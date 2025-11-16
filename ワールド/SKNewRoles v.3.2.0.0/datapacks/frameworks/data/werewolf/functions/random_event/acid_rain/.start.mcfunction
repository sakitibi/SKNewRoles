#イベント開始フラグ
data modify storage sys: random_event.2.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
execute as @a at @s run playsound minecraft:Phantom1 master @s
#shuffleリストの先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.3","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"acid_rain.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"acid_rain.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: acid_rain.title
data modify storage sys: random_event.content.1 set from storage wolf_data: acid_rain.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: acid_rain.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: acid_rain.content.3

#制限時間を50秒に
execute unless entity @a[team=Witch] run scoreboard players set GameManager event_timer_countdown 1000
execute if entity @a[team=Witch] run scoreboard players set GameManager event_timer_countdown 2000
#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#イベントの再帰処理
execute unless score GameManager forest_rain matches 1 run function werewolf:random_event/acid_rain/.on_going
execute if score GameManager forest_rain matches 1 run function werewolf:random_event/acid_rain/.on_going_forest