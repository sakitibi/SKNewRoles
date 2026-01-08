#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

execute as @a[predicate=werewolf:look_at/random_event/look_at_boss_event_axolotl] run title @s actionbar {"text":"住処に帰す (右クリック)"}

execute at @e[type=axolotl,tag=event_axolotl,tag=!boss_axolotl] run particle minecraft:effect ~ ~-0.5 ~ 3 0 3 0 2 force @a
execute unless entity @a[team=Witch] at @e[type=axolotl,tag=event_axolotl,tag=!boss_axolotl] as @a[distance=..3,predicate=!werewolf:is_effects/poison] run effect give @s poison 1 3 true
execute if entity @a[team=Witch] at @e[type=axolotl,tag=event_axolotl,tag=!boss_axolotl] as @a[distance=..3,predicate=!werewolf:is_effects/poison] run effect give @s[team=Witch] poison 1 1 true
execute if entity @a[team=Witch] at @e[type=axolotl,tag=event_axolotl,tag=!boss_axolotl] as @a[distance=..3,predicate=!werewolf:is_effects/poison] run effect give @s[team=!Witch,tag=!no_jinrou] poison 1 3 true
execute if entity @a[team=Witch] at @e[type=axolotl,tag=event_axolotl,tag=!boss_axolotl] as @a[distance=..3,predicate=!werewolf:is_effects/poison] run effect give @s[team=!Witch,tag=no_jinrou] poison 2 5 true
execute at @e[type=axolotl,tag=event_axolotl,tag=boss_axolotl] run particle minecraft:crit ~ ~ ~ 0.5 0.5 0.5 0 1 force @a
execute as @e[type=axolotl,tag=boss_axolotl] at @s run tp @e[type=interaction,tag=boss_axolotl] @s
execute as @e[type=interaction,tag=boss_axolotl] if data entity @s interaction run kill @s

#イベント終了処理
execute if score GameManager event_timer_countdown matches 0 run data modify storage sys: random_event.4.active set value 2
execute unless entity @e[type=interaction,tag=boss_axolotl] unless data storage sys: random_event.4{active:9} run data modify storage sys: random_event.4.active set value 2
execute unless entity @e[type=axolotl,tag=event_axolotl] unless data storage sys: random_event.4{active:9} run data modify storage sys: random_event.4.active set value 2
execute if data storage sys: random_event.4{active:2} unless score GameManager event_timer_countdown matches 0 run title @a title {"interpret":true,"nbt":"quest_success","storage":"wolf_data:"}
execute if data storage sys: random_event.4{active:2} unless score GameManager event_timer_countdown matches 0 run tellraw @a {"interpret":true,"nbt":"poison_axolotl.announce.success.1","storage":"wolf_data:"}
execute if data storage sys: random_event.4{active:2} if score GameManager event_timer_countdown matches 0 run title @a title {"interpret":true,"nbt":"quest_failed","storage":"wolf_data:"}
execute if data storage sys: random_event.4{active:2} if score GameManager event_timer_countdown matches 0 run tellraw @a {"interpret":true,"nbt":"poison_axolotl.announce.failed.1","storage":"wolf_data:"}

#デスポーンの演出
execute if data storage sys: random_event.4{active:2} run execute at @e[type=axolotl,tag=event_axolotl] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#デスポーン
execute if data storage sys: random_event.4{active:2} run tp @e[type=axolotl,tag=event_axolotl] ~ ~-1000 ~
execute if data storage sys: random_event.4{active:2} run kill @e[type=axolotl,tag=event_axolotl]
execute if data storage sys: random_event.4{active:2} run kill @e[type=interaction,tag=event_axolotl]

#イベント詳細をまとめて削除
execute if data storage sys: random_event.4{active:2} run schedule function werewolf:random_event/event_clear 1s
#イベント判定を進行
execute if data storage sys: random_event.4{active:2} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.4{active:1} run schedule function werewolf:random_event/poison_axolotl/.on_going 1t