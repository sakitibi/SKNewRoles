#イベント開始フラグ
data modify storage sys: random_event.6.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffleリストの先頭を削除
data remove storage sys: random_event.shuffle[0]
#納品数設定
data modify storage sys: random_event.6.delivery set value 10

title @a title {"interpret":true,"nbt":"quest_announce.3","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"delivery_bread.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"delivery_bread.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: delivery_bread.title
data modify storage sys: random_event.content.1 set from storage wolf_data: delivery_bread.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: delivery_bread.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: delivery_bread.content.3

#制限時間を設定
scoreboard players set GameManager event_timer_countdown 1000

#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#納品箱設置
#execute at @e[type=marker,tag=delivery_box] align xyz run summon block_display ~ ~ ~ {block_state:{Name:"barrel",Properties:{facing:"up"}},Tags:["delivery_bread","event"],Glowing:true}
execute at @e[type=marker,tag=delivery_box] align xyz run summon item_display ~0.5 ~0.51 ~0.5 {item:{id:"bread",Count:1b,tag:{CustomModelData:2}},Tags:["delivery_bread","delivery_box","event"],Glowing:true}
team join Glowing_red @e[type=item_display,tag=delivery_bread,tag=delivery_box,tag=event]
execute at @e[type=marker,tag=delivery_box] align xyz run setblock ~ ~ ~ barrier
#execute at @e[type=marker,tag=delivery_box] align xyz run summon item ~0.5 ~1.3 ~0.5 {Item:{id:"minecraft:bread",Count:1b},Tags:["delivery_bread","event"],PickupDelay:100000,NoGravity:true}
execute at @e[type=marker,tag=delivery_box] align xyz run summon interaction ~0.5 ~1.01 ~0.5 {Tags:["delivery_bread","delivery_box","event"],width:1.01f,height:-1.01f}
#納品箱アナウンス
execute at @e[type=marker,tag=delivery_box] align xyz run summon text_display ~0.5 ~1.5 ~0.5 {text:'{"text":"納品BOX"}',Tags:["delivery_bread","event"],Rotation:[-90f,0f],billboard:"vertical"}
#演出
execute at @e[type=marker,tag=delivery_box] align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a

#イベントの再帰処理
function werewolf:random_event/delivery_bread/.on_going