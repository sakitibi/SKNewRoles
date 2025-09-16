#イベント開始フラグ
data modify storage sys: random_event.1.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffleリストの先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.3","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"monster_stampede.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"monster_stampede.announce..2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: monster_stampede.title
data modify storage sys: random_event.content.1 set from storage wolf_data: monster_stampede.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: monster_stampede.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: monster_stampede.content.3

#制限時間を50秒に
scoreboard players set GameManager event_timer_countdown 1000

#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#わかりやすいように発光させる
execute at @e[type=marker,tag=re_button_1] align xyz run data merge entity @e[type=item_display,tag=re_button_1,sort=nearest,limit=1] {Glowing:true}
execute at @e[type=marker,tag=re_button_2] align xyz run data merge entity @e[type=item_display,tag=re_button_2,sort=nearest,limit=1] {Glowing:true}
#イベントの再帰処理
function werewolf:random_event/monster_stampede/.on_going