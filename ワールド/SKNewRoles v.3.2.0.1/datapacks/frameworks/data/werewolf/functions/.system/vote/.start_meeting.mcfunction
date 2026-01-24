#緊急会議の演出
title @a title [{"text":"\uF811\uE200\uF811","font":"announce"}]
execute as @a at @s run playsound minecraft:start_meeting master @s

#プレイヤーを投票可能に
scoreboard players set @a[team=!Tenkai] can_vote 0

#ゲームフェイズを会議に
data modify storage sys: game_phase set value 99

#会議時間を設定
scoreboard players operation GameManager meeting_timer = GameManager set_meeting_time

#ボスバー名を変更
bossbar set time_bossbar name "会議時間"
execute store result bossbar time_bossbar max run scoreboard players get GameManager set_meeting_time


#全員を会議場所へtp
tp @a @e[type=marker,tag=meeting_room,limit=1]
scoreboard players set GameManager meeting 1

#投票をリセット
scoreboard players set GameManager votes 0
scoreboard players set @a votes 0
scoreboard players set @a[team=Serialkiller] serialkiller_countdown 99999
scoreboard players set @a[team=Serialkiller] serialkiller_killcooldown 99999
scoreboard players set GameManager vote_skip 0

#投票用チャットを表示
schedule function werewolf:.system/vote/vote_chat 5s

difficulty hard

#墓をキル
kill @e[tag=grave]