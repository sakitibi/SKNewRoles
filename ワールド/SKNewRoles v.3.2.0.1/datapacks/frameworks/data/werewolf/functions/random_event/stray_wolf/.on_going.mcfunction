#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

execute as @a[predicate=werewolf:look_at/random_event/look_at_event_wolf] run title @s actionbar {"text":"手懐ける (右クリック)"}

execute as @e[type=wolf,tag=event_wolf,tag=no_tame] at @s run tp @e[type=interaction,tag=event_wolf] @s

#イベント終了処理
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.5.active set value 2
execute if data storage sys: random_event.5{active:2} run title @a title {"interpret":true,"nbt":"quest_failed","storage":"wolf_data:"}
execute if data storage sys: random_event.5{active:2} run tellraw @a {"interpret":true,"nbt":"stray_wolf.announce.failed.1","storage":"wolf_data:"}
execute unless entity @e[type=interaction,tag=event_wolf] run data modify storage sys: random_event.5.active set value 2
execute unless entity @e[type=wolf,tag=event_wolf,tag=no_tame] run data modify storage sys: random_event.5.active set value 2

#デスポーンの演出
execute if data storage sys: random_event.5{active:2} run execute at @e[type=wolf,tag=event_wolf,tag=no_tame] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#デスポーン
execute if data storage sys: random_event.5{active:2} as @e[type=wolf,tag=event_wolf,tag=no_tame] unless data entity @s Owner run tp @s ~ ~-1000 ~
execute if data storage sys: random_event.5{active:2} as @e[type=wolf,tag=event_wolf,tag=no_tame] unless data entity @s Owner run kill @s
execute if data storage sys: random_event.5{active:2} as @e[type=interaction,tag=event_wolf] run kill @s

#イベント詳細をまとめて削除
execute if data storage sys: random_event.5{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.5{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.5{active:1} run schedule function werewolf:random_event/stray_wolf/.on_going 1t