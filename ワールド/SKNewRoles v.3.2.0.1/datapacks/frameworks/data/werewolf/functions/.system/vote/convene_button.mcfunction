#招集者を記録
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=1] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=1]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=2] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=2]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=3] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=3]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=4] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=4]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=5] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=5]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=6] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=6]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=7] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=7]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=8] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=8]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=9] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=9]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=10] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=10]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=11] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=11]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=12] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=12]"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} as @s[tag=13] run data modify storage sys: meeting.convener set value '[{"selector":"@a[tag=13]"}]'
#招集方法を記録
#data modify storage sys: meeting.cause set value '[{"text":"墓の発見"}]'
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} run data modify storage sys: meeting.cause set value '[{"text":"会議ボタン"}]'

#ボタンを制限
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} run scoreboard players set @s meeting_button 1

#会議を開始
execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 if data storage sys: {item_phase:0} run function werewolf:.system/vote/.start_meeting


#エラー通知
#execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} unless data storage sys: random_event{title:''} if score GameManager can_convence matches 0 run tellraw @s "今は緊急会議を招集できない"
#execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} unless data storage sys: random_event{title:''} if score GameManager can_convence matches 1 run tellraw @s "今は緊急会議を招集できない"
#execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 0 run tellraw @s "今は緊急会議を招集できない"
#execute if data storage sys: {game_phase:1} if data storage sys: meeting{active:0} if data storage sys: random_event{title:''} if score GameManager can_convence matches 1 run tellraw @s "今は緊急会議を招集できない"

advancement revoke @s only werewolf:meeting/convence