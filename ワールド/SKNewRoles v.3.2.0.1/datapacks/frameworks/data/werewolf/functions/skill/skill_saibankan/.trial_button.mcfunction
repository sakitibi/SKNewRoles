#招集者を記録
execute if entity @a[tag=player,team=Saibankan] run data modify storage sys: meeting.convener set value '[{"text":"裁判官"}]'
execute unless entity @a[tag=player,team=Saibankan] if entity @a[tag=player,tag=saibankan_1] run data modify storage sys: meeting.convener set value '[{"text":"裁判官(後任)"}]'
#招集方法を記録
data modify storage sys: meeting.cause set value '[{"text":"役職による能力(ボタン)"}]'

#会議を開始
execute if data storage sys: random_event{title:''} if data storage sys: {item_phase:0} as @s[scores={meeting_button=0}] run function werewolf:.system/vote/._meeting

#ボタンを制限
execute if data storage sys: random_event{title:''} if data storage sys: {item_phase:0} as @s[scores={meeting_button=0}] run scoreboard players set @s meeting_button 1


advancement revoke @s only werewolf:meeting/successor_convence