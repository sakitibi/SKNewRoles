#招集者を記録
execute if entity @a[tag=player,team=Saibankan] run data modify storage sys: meeting.convener set value '[{"text":"裁判官"}]'
execute unless entity @a[tag=player,team=Saibankan] if entity @a[tag=player,tag=saibankan_1] run data modify storage sys: meeting.convener set value '[{"text":"裁判官(後任)"}]'
#招集方法を記録
data modify storage sys: meeting.cause set value '[{"text":"役職による能力"}]'

#会議を開始
function werewolf:.system/vote/.start_meeting