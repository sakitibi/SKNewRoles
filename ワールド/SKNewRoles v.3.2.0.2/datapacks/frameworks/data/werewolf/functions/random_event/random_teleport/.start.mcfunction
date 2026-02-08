#イベント開始フラグ
data modify storage sys: random_event.7.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffle配列の先頭を削除
data remove storage sys: random_event.shuffle[0]

#アナウンス
title @a title {"interpret":true,"nbt":"quest_announce.3","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"random_teleport.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"random_teleport.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: random_teleport.title
data modify storage sys: random_event.content.1 set from storage wolf_data: random_teleport.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: random_teleport.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: random_teleport.content.3

#制限時間を設定
scoreboard players set GameManager event_timer_countdown 60
#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#イベントの再帰処理
function werewolf:random_event/random_teleport/.on_going