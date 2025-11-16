
# 緊急会議用に死亡したプレイヤーを一時保存
execute as @s[tag=1] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=1]"}]'
execute as @s[tag=2] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=2]"}]'
execute as @s[tag=3] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=3]"}]'
execute as @s[tag=4] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=4]"}]'
execute as @s[tag=5] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=5]"}]'
execute as @s[tag=6] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=6]"}]'
execute as @s[tag=7] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=7]"}]'
execute as @s[tag=8] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=8]"}]'
execute as @s[tag=9] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=9]"}]'
execute as @s[tag=10] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=10]"}]'
execute as @s[tag=11] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=11]"}]'
execute as @s[tag=12] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=12]"}]'
execute as @s[tag=13] run data modify storage sys: meeting.dead append value '[{"selector":"@a[tag=13]"}]'

#落とし穴のスコアリセット
scoreboard players set @s fall_into_a_pitfall 0

#キューピットのタグ削除
execute if score GameManager lovers_full matches 0 run tag @s remove lovers

# ペットの狼処理
function werewolf:random_event/stray_wolf/death_owner

# 死亡時に天界へ送る
team join Tenkai
# 墓を召喚する準備
function werewolf:.system/grave/preparation_create_grave
#playerタグを削除
tag @s remove player
# 死亡カウントをリセット
scoreboard players set @a[scores={death=1..}] death 0