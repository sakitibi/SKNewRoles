#イベント開始フラグ
data modify storage sys: random_event.10.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffleリストの先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"hidden_property.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"hidden_property.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: hidden_property.title
data modify storage sys: random_event.content.1 set from storage wolf_data: hidden_property.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: hidden_property.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: hidden_property.content.3

#制限時間を50秒に
scoreboard players set GameManager event_timer_countdown 1000
#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#チェストをランダムに一つ配置
tag @e[type=marker,tag=chest_point,sort=random,limit=1] add this
execute as @e[type=marker,tag=chest_point,tag=this] at @s run function werewolf:random_event/hidden_property/chest/set_chest

#イベントの再帰処理
function werewolf:random_event/hidden_property/.on_going