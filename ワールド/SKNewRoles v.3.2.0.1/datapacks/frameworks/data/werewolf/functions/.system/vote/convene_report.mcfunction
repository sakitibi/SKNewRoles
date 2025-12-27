#招集者を記録
execute as @s[tag=1] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=1]"}]'
execute as @s[tag=2] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=2]"}]'
execute as @s[tag=3] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=3]"}]'
execute as @s[tag=4] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=4]"}]'
execute as @s[tag=5] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=5]"}]'
execute as @s[tag=6] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=6]"}]'
execute as @s[tag=7] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=7]"}]'
execute as @s[tag=8] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=8]"}]'
execute as @s[tag=9] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=9]"}]'
execute as @s[tag=10] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=10]"}]'
execute as @s[tag=11] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=11]"}]'
execute as @s[tag=12] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=12]"}]'
execute as @s[tag=13] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=13]"}]'
#招集方法を記録
data modify storage sys: meeting.cause set value '[{"text":"墓の発見"}]'
#data modify storage sys: meeting.cause set value '[{"text":"会議ボタン"}]'

#会議を開始
function werewolf:.system/vote/.start_meeting