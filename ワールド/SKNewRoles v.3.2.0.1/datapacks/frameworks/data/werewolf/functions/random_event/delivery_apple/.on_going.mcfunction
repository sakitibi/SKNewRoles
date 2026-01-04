#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar


#アクションバー設定
execute as @a[predicate=werewolf:look_at/random_event/look_at_delivery_box,nbt={Inventory:[{id:"minecraft:apple"}]}] run title @s actionbar [{"text":"納品する (\uE501右クリック)"},{"text":" [残り:"},{"nbt":"random_event.8.delivery","storage":"sys:"},{"text":"個]"}]
execute as @a[predicate=werewolf:look_at/random_event/look_at_delivery_box,nbt=!{Inventory:[{id:"minecraft:apple"}]}] run title @s actionbar [{"text":" [残り納品数:"},{"nbt":"random_event.8.delivery","storage":"sys:"},{"text":"個]"}]


#タスク用のinteraction処理
execute as @e[type=minecraft:interaction,tag=fruit] at @s if data entity @s attack.player run function werewolf:random_event/delivery_apple/kill_fruit


#納品達成でイベント終了処理
execute if data storage sys: random_event.8{active:1,delivery:0} run data modify storage sys: random_event.8.active set value 2
execute if data storage sys: random_event.8{active:2} run title @a title {"interpret":true,"nbt":"quest_success","storage":"wolf_data:"}
execute if data storage sys: random_event.8{active:2} run tellraw @a {"interpret":true,"nbt":"delivery_apple.announce.success.1","storage":"wolf_data:"}

#タイムアップ
execute if data storage sys: random_event.8{active:1} if score GameManager event_timer_countdown matches ..0 run data modify storage sys: random_event.8.active set value 3
execute if data storage sys: random_event.8{active:3} run title @a title {"interpret":true,"nbt":"quest_failed","storage":"wolf_data:"}
execute if data storage sys: random_event.8{active:3} run tellraw @a {"interpret":true,"nbt":"delivery_apple.announce.failed.1","storage":"wolf_data:"}
#ペナルティ設定
execute if data storage sys: random_event.8{active:3} run function werewolf:random_event/delivery_apple/.schedule_penalty


#おかたづけ
#イベント詳細をまとめて削除
execute unless data storage sys: random_event.8{active:1} run schedule function werewolf:random_event/event_clear 1s

#納品箱撤去
execute unless data storage sys: random_event.8{active:1} run execute at @e[type=marker,tag=delivery_box] align xyz run setblock ~ ~ ~ air replace
execute unless data storage sys: random_event.8{active:1} run kill @e[tag=delivery_apple]
#果実を削除
execute unless data storage sys: random_event.8{active:1} run kill @e[type=!marker,tag=fruit]
#演出
execute unless data storage sys: random_event.8{active:1} at @e[type=marker,tag=delivery_box] align xyz run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 10 force @a
#bearタグを削除
execute unless data storage sys: random_event.8{active:1} run tag @s remove bear

#イベントの終了フラグ
execute unless data storage sys: random_event.8{active:1} run data modify storage sys: random_event.8.active set value 0
#イベント判定を進行
execute unless data storage sys: random_event.8{active:1} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.8{active:1} run schedule function werewolf:random_event/delivery_apple/.on_going 1t
