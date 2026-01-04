#制限時間の処理
scoreboard players remove GameManager event_timer_countdown 1
scoreboard players remove GameManager event_timer_update 1
execute if score GameManager event_timer_update matches ..0 run function werewolf:random_event/event_bar

#的破壊処理
#execute as @e[type=minecraft:marker,tag=target,tag=this] at @s unless block ~ ~ ~ minecraft:target[power=0] unless block ~ ~ ~ minecraft:air run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
#execute as @e[type=minecraft:marker,tag=target,tag=this] at @s unless block ~ ~ ~ minecraft:target[power=0] unless block ~ ~ ~ minecraft:air run kill @e[type=block_display,tag=target,sort=nearest,limit=1]
#execute as @e[type=minecraft:marker,tag=target,tag=this] at @s unless block ~ ~ ~ minecraft:target[power=0] unless block ~ ~ ~ minecraft:air run kill @e[type=arrow,limit=1,sort=nearest]
#execute as @e[type=minecraft:marker,tag=target,tag=this] at @s unless block ~ ~ ~ minecraft:target[power=0] unless block ~ ~ ~ minecraft:air run tag @s remove this
#execute as @e[type=minecraft:marker,tag=target] at @s unless block ~ ~ ~ minecraft:target[power=0] unless block ~ ~ ~ minecraft:air run setblock ~ ~ ~ minecraft:air

#ファントムをその場に拘束
execute as @e[type=minecraft:marker,tag=target,tag=this] at @s run tp @e[type=minecraft:phantom,distance=..2] ~ ~ ~

#イベントクリア処理
execute unless entity @e[type=minecraft:phantom,tag=target] unless data storage sys: random_event.9{active:9} run data modify storage sys: random_event.9.active set value 2
execute if data storage sys: random_event.9{active:2} run title @a title {"interpret":true,"nbt":"quest_success","storage":"wolf_data:"}
execute if data storage sys: random_event.9{active:2} run tellraw @a {"interpret":true,"nbt":"hit_the_target.announce.success.1","storage":"wolf_data:"}
#execute if data storage sys: random_event.9{active:2} run effect give @a[tag=!camp_red],[team=!Witch] saturation 1 200

#タイムアップ
execute if data storage sys: random_event.9{active:1} if score GameManager event_timer_countdown matches ..0 run data modify storage sys: random_event.9.active set value 3
execute if data storage sys: random_event.9{active:3} run title @a title {"interpret":true,"nbt":"quest_failed","storage":"wolf_data:"}
execute if data storage sys: random_event.9{active:3} run tellraw @a {"interpret":true,"nbt":"hit_the_target.announce.failed.1","storage":"wolf_data:"}
#ペナルティ設定
execute if data storage sys: random_event.9{active:3} run function werewolf:random_event/hit_the_target/.schedule_penalty


#おかたづけ
#イベント詳細をまとめて削除
execute unless data storage sys: random_event.9{active:1} run schedule function werewolf:random_event/event_clear 1s

#的撤去
#execute unless data storage sys: random_event.9{active:1} run execute at @e[type=marker,tag=target] align xyz run setblock ~ ~ ~ air replace
#execute unless data storage sys: random_event.9{active:1} run kill @e[type=block_display,tag=target]
#execute unless data storage sys: random_event.9{active:1} run tag @e[type=minecraft:marker,tag=target,tag=this] remove this

#ファントム撤去
#execute unless data storage sys: random_event.9{active:1} run execute at @e[type=marker,tag=protect_phantom] run setblock ~ ~ ~ air replace
execute unless data storage sys: random_event.9{active:1} run tp @e[type=phantom,tag=target] ~ ~-1000 ~
execute unless data storage sys: random_event.9{active:1} run kill @e[type=phantom,tag=target]
execute unless data storage sys: random_event.9{active:1} run tag @e[type=minecraft:marker,tag=target,tag=this] remove this


#イベントの終了フラグ
execute unless data storage sys: random_event.9{active:1} run data modify storage sys: random_event.9.active set value 0
#イベント判定を進行
execute unless data storage sys: random_event.9{active:1} run scoreboard players set GameManager event_timer -2

#再帰処理
execute if data storage sys: random_event.9{active:1} run schedule function werewolf:random_event/hit_the_target/.on_going 1t
