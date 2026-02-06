#イベント開始フラグ
data modify storage sys: random_event.4.active set value 1
#クエスト発生で効果音を鳴らす
execute as @a at @s run playsound minecraft:quest_start master @s
#shuffle配列の先頭を削除
data remove storage sys: random_event.shuffle[0]

title @a title {"interpret":true,"nbt":"quest_announce.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"poison_axolotl.announce.start.1","storage":"wolf_data:"}
tellraw @a {"interpret":true,"nbt":"poison_axolotl.announce.start.2","storage":"wolf_data:"}

#イベント詳細を設定
data modify storage sys: random_event.title set from storage wolf_data: poison_axolotl.title
data modify storage sys: random_event.content.1 set from storage wolf_data: poison_axolotl.content.1
data modify storage sys: random_event.content.2 set from storage wolf_data: poison_axolotl.content.2
data modify storage sys: random_event.content.3 set from storage wolf_data: poison_axolotl.content.3

#制限時間を50秒に
scoreboard players set GameManager event_timer_countdown 1000

#イベントバーの初期設定
function werewolf:random_event/event_bar_setting

#ランダムイベント判定を停止
scoreboard players set GameManager event_timer -1

#ウーパールーパーを召喚
execute at @e[type=marker,tag=spawner,limit=1,sort=random] run summon axolotl ~ ~1 ~ {Variant:4,Invulnerable:true,Tags:["boss_axolotl","event_axolotl","event"],PersistenceRequired:true}
#毒ウーパーが何匹か指定
execute at @e[type=axolotl,tag=boss_axolotl] at @e[type=marker,tag=spawner,distance=2..,limit=7,sort=random] run summon axolotl ~ ~1 ~ {Variant:5,Invulnerable:true,Tags:["event_axolotl","event"]}
execute at @e[type=axolotl,tag=event_axolotl] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
execute as @e[type=axolotl,tag=boss_axolotl] at @s run summon interaction ~ ~ ~ {Tags:["boss_axolotl","event_axolotl","event"],width:1f,height:0.7f}

#イベントの再帰処理
function werewolf:random_event/poison_axolotl/.on_going
