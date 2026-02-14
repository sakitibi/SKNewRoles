#イベント開始フラグ
data modify storage sys: random_event.11.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffle配列の先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"ancient_hidden_room.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"ancient_hidden_room.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: ancient_hidden_room.title
data modify storage sys: random_event.content.1 set from storage wolf_data: ancient_hidden_room.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: ancient_hidden_room.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: ancient_hidden_room.content.3

#制限時間を50秒に
scoreboard players set GameManager event_timer_countdown 1000
#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1
#氷剣を召喚
function werewolf:random_event/ancient_hidden_room/ice_sword/sumon
#氷剣を光らせる
data modify entity @e[type=minecraft:item_display,tag=ice_sword,limit=1] Glowing set value true

#イベントの再帰処理
function werewolf:random_event/ancient_hidden_room/.on_going