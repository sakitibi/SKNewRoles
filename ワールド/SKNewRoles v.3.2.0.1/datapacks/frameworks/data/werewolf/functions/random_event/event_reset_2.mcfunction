# 個別に対処
#天候をリセット
weather clear
#納品箱をおかたづけ
execute at @e[type=marker,tag=delivery_box] align xyz run setblock ~ ~ ~ air replace
#発光を消灯
execute at @e[type=marker,tag=re_button_1] align xyz run data merge entity @e[type=item_display,tag=re_button_1,sort=nearest,limit=1] {Glowing:false}
execute at @e[type=marker,tag=re_button_2] align xyz run data merge entity @e[type=item_display,tag=re_button_2,sort=nearest,limit=1] {Glowing:false}
schedule clear werewolf:random_event/monster_stampede/.time_up
schedule clear werewolf:random_event/monster_stampede/.end
#オオカミは特別に
execute at @e[type=wolf,tag=event_wolf] run particle minecraft:cloud ~0.5 ~ ~0.5 1 1 1 0 5 force @a
tp @e[type=wolf,tag=event_wolf] ~ ~-1000 ~
#bearタグを削除
tag @e[type=marker,tag=fruit,tag=bear] remove bear
#的のタグを削除
tag @e[type=minecraft:marker,tag=target,tag=this] remove this
#日陰用ブロックを削除
#execute at @e[type=marker,tag=protect_phantom] run setblock ~ ~ ~ air replace
#村長チェストを削除
execute as @e[type=marker,tag=chest_point,tag=this] at @s run data modify block ~ ~ ~ LootTable set value "werewolf:random_event/event_10/remove"
execute as @e[type=marker,tag=chest_point,tag=this] at @s run data remove block ~ ~ ~ Items
execute as @e[type=marker,tag=chest_point] at @s run setblock ~ ~ ~ air replace
execute as @e[type=marker,tag=chest_point,tag=this] run tag @s remove this

#イベントモブをキル
kill @e[tag=event]