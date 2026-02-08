#イベント開始フラグ
data modify storage sys: random_event.9.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffle配列の先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.3","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"hit_the_target.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"hit_the_target.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: hit_the_target.title
data modify storage sys: random_event.content.1 set from storage wolf_data: hit_the_target.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: hit_the_target.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: hit_the_target.content.3

#制限時間を設定 100秒
scoreboard players set GameManager event_timer_countdown 2000

#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1


#的を設置
#execute as @e[type=marker,tag=target,sort=random,limit=5] run tag @s add this
#execute at @e[type=marker,tag=target,tag=this] run setblock ~ ~ ~ target[power=0]
#execute at @e[type=marker,tag=target,tag=this] align xyz positioned ~ ~ ~ run summon block_display ~ ~-0.05 ~ {block_state:{Name:"target"},Tags:["target","event"],Glowing:true,width:1.01f,height:1.01f}

#場所の抽選
tag @e[type=marker,tag=target,sort=random,limit=8] add this
#日陰を用意
#execute at @e[type=marker,tag=protect_phantom] run setblock ~ ~ ~ cobweb
#ファントムを召喚
execute at @e[type=marker,tag=target,tag=this] run summon minecraft:phantom ~ ~ ~ {Health:1,Size:5,Tags:["target","event"],DeathLootTable:"",PersistenceRequired:true}

#summon block_display ~ ~ ~ {block_state:{Name:"barrel",Properties:{facing:"up"}},Tags:["delivery_bread","event"],Glowing:true}
#execute at @e[type=marker,tag=delivery_box] align xyz run setblock ~ ~ ~ barrier
#execute at @e[type=marker,tag=delivery_box] align xyz run summon item ~0.5 ~1.3 ~0.5 {Item:{id:"minecraft:bread",Count:1b},Tags:["delivery_bread","event"],PickupDelay:100000,NoGravity:true}
#execute at @e[type=marker,tag=delivery_box] align xyz run summon interaction ~0.5 ~1.01 ~0.5 {Tags:["delivery_bread","delivery_box","event"],width:1.01f,height:-1.01f}
#演出
execute at @e[type=marker,tag=target,tag=this] align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a


#イベントの再帰処理
function werewolf:random_event/hit_the_target/.on_going