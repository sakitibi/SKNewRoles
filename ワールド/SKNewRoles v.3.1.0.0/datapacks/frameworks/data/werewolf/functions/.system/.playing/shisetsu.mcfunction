#墓を生成
    execute as @e[type=item,tag=grave,tag=not_yet,predicate=werewolf:location_check/in_liquid] at @s run function werewolf:.system/grave/create_grave
    execute as @e[type=item,tag=grave,tag=not_yet,nbt={OnGround:1b}] at @s run function werewolf:.system/grave/create_grave
#墓をわかりやすく
    execute if entity @e[type=interaction,tag=grave] at @e[type=interaction,tag=grave] run particle effect ~ ~-0.25 ~ 0.05 -1 1 5 0
#ベント処理(ポンコツ狼無し)
schedule function werewolf:.system/.playing/vent
# タスク関連
    schedule function werewolf:.system/.playing/tasks 1t append false
# ランダムイベント処理
    execute if data storage sys: {event_active:0} if data storage sys: {time_phase:day} if score GameManager event_timer matches 0.. run scoreboard players remove GameManager event_timer 1
    execute if data storage sys: {event_active:0} if score GameManager event_timer matches 0 unless score GameManager common_timer matches ..1100 run function werewolf:random_event/event_selection

    #氷剣エフェクト
    execute as @e[type=minecraft:item_display,tag=ice_sword] at @s run particle minecraft:crit ~ ~ ~ 0.2 0.8 0.2 0 3 force @a
    #アナウンス
    execute as @a[predicate=werewolf:look_at/look_at_ice_sword] run title @s actionbar [{"text":"氷の剣を引き抜く (\uE501右クリック)"}]