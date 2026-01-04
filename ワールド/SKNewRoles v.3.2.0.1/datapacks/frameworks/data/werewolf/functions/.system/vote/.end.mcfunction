data remove storage sys: meeting.convener
data remove storage sys: meeting.cause
data remove storage sys: meeting.dead

#エフェクトをリセット
effect clear @a

#難易度を元に戻す
difficulty hard

#処刑対象をキル処理
#playerタグを削除
execute as @a[team=!Tenkai,tag=hang] run tag @s remove player
#天界へ送る
execute as @a[team=!Tenkai,tag=hang] run team join Tenkai
execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_countdown 2400
execute if score GameManager skill_serialkiller_frequency matches 1 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 20
execute if score GameManager skill_serialkiller_frequency matches 2 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 40
execute if score GameManager skill_serialkiller_frequency matches 3 run execute as @s[team=Serialkiller] run scoreboard players set @s serialkiller_killcooldown 60

#ボスバー名を戻す
bossbar set time_bossbar name [{"interpret":true,"nbt":"bossbar_text","storage":"sys:"}]
#bossbar set time_bossbar name [{"interpret":true,"nbt":"time_text","storage":"sys:"},{"interpret":true,"nbt":"random_event.title","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.1","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.2","storage":"sys:"},{"interpret":true,"nbt":"random_event.content.3","storage":"sys:"},{"interpret":true,"nbt":"random_event.bar","storage":"sys:"}]
execute if data storage sys: {time_text:'{"text":"初日の昼時間","color":"white"}'} store result bossbar time_bossbar max run scoreboard players get GameManager set_first_daytime
execute if data storage sys: {time_text:'{"text":"昼時間","color":"white"}'} store result bossbar time_bossbar max run scoreboard players get GameManager set_daytime
execute if data storage sys: {time_text:'{"text":"夜時間","color":"white"}'} store result bossbar time_bossbar max run scoreboard players get GameManager set_nighttime

#プレイヤーをフィールドへtp
function werewolf:.system/set_player/
scoreboard players set GameManager meeting 0

#ゲームフェイズを戻す
data modify storage sys: game_phase set value 1