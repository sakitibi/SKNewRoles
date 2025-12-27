#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute unless entity @a[team=Witch,tag=Sorceress] run scoreboard players set GameManager forest_rain_types 0
execute if entity @a[team=Witch,tag=Sorceress] run scoreboard players random GameManager forest_rain_types 0 19
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar
execute if score GameManager forest_rain_types matches 19 run tellraw @a {"interpret":true,"nbt":"acid_rain.announce.start.3","storage":"wolf_data:"}
execute unless score GameManager forest_rain_types matches 19 run tellraw @a {"interpret":true,"nbt":"acid_rain.announce.start.4","storage":"wolf_data:"}
execute if score GameManager forest_rain_types matches 19 run tellraw @a[tag=forest_skill_used] [{"text":"魔女によって雨に毒をかけられてしまった!","color":"red"}]
execute unless score GameManager forest_rain_types matches 19 run tellraw @a[tag=forest_skill_used] [{"selector":"@a[tag=forest_skill_used]","color":"green"},{"text":"は雨に当たったら回復出来る!","color":"green"}]
tag @a[tag=forest_skill_used] remove forest_skill_used
#天候を雨に
execute unless entity @a[team=Witch] if score GameManager event_timer_countdown matches 1000 run weather rain
execute if entity @a[team=Witch] if score GameManager event_timer_countdown matches 2000 run weather rain

#傘を持っておらず頭上にブロックがなければウィザー状態を付与
execute if score GameManager event_timer_countdown matches ..2000 run execute unless score GameManager forest_rain_types matches 19 run execute as @a[predicate=werewolf:have_item/umbrella] at @s positioned over motion_blocking if entity @s[dy=999] run effect give @s[team=Forest] regeneration 1 0 true
execute if score GameManager event_timer_countdown matches ..1900 run execute unless score GameManager forest_rain_types matches 19 run execute as @a[predicate=werewolf:have_item/umbrella] at @s positioned over motion_blocking if entity @s[dy=999] run effect give @s[team=!Forest,team=!Witch] wither 1 3 true

#イベント終了処理
execute if score GameManager event_timer_countdown matches 90 run weather clear
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.2.active set value 2
execute if data storage sys: random_event.2{active:2} run tellraw @a {"interpret":true,"nbt":"acid_rain.announce.end.1","storage":"wolf_data:"}
execute if score GameManager forest_rain_types matches 19 run execute if data storage sys: random_event.2{active:2} run tellraw @a {"interpret":true,"nbt":"acid_rain.announce.end.2","storage":"wolf_data:"}
execute unless score GameManager forest_rain_types matches 19 run execute if data storage sys: random_event.2{active:2} run tellraw @a {"interpret":true,"nbt":"acid_rain.announce.end.3","storage":"wolf_data:"}
execute if score GameManager event_timer_countdown matches 0 run scoreboard players set GameManager forest_rain 0
execute if score GameManager event_timer_countdown matches 0 run scoreboard players set GameManager forest_rain_types 0
#execute if data storage sys: random_event.2{active:2} run weather clear

#イベント詳細をまとめて削除
execute if data storage sys: random_event.2{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.2{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.2{active:1} run schedule function werewolf:random_event/acid_rain/.on_going 1t append false