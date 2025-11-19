#イベント開始フラグ
data modify storage sys: random_event.5.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_ master @s
#shuffleリストの先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"stray_wolf.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"stray_wolf.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: stray_wolf.title
data modify storage sys: random_event.content.1 set from storage wolf_data: stray_wolf.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: stray_wolf.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: stray_wolf.content.3

#制限時間を50秒に
scoreboard players set GameManager event_timer_countdown 1000

#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#オオカミを召喚
execute at @e[type=marker,tag=spawner,limit=1,sort=random] run summon wolf ~ ~1 ~ {Invulnerable:true,Age:-32768,Tags:["event_wolf","no_tame","event"],PersistenceRequired:true}
effect give @e[type=wolf,tag=event_wolf,tag=no_tame] weakness infinite 100 true
execute at @e[type=wolf,tag=event_wolf,tag=no_tame] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
execute as @e[type=wolf,tag=event_wolf,tag=no_tame] at @s run summon interaction ~ ~ ~ {Tags:["event_wolf","event"],width:0.7f,height:0.7f}

#イベントの再帰処理
function werewolf:random_event/stray_wolf/.on_going
